//our good old FIFER

module fifer(
    input wire i_clock,
    input wire reset,
    input wire data_in_valid,
    input [7:0] data_in,
    input wire read_ready,
    output reg [7:0] data_out,
    output reg data_out_valid,
    output wire full,
    output wire empty
    );
    reg [3:0] size;
    
    reg [63:0] nums;
    
    assign empty = (size == 4'd0);
    assign full = (size == 4'd8);
    
    always @(negedge i_clock) begin
        data_out_valid <= (read_ready && ~empty);
    end
    
    always @(negedge i_clock or negedge reset) begin
        if (reset) begin
            size <= 0;
            nums <= 0;
        end else begin
            if (read_ready && ~data_in_valid) begin
                if (size > 0) begin
                    data_out <= nums[7:0];
                    nums = {8'b0, nums[63:8]};
                    size <= size - 1;
                end else data_out <= 0;
            end else
            if (data_in_valid && ~read_ready) begin
                if (size < 8) begin
                    nums[8*size +: 8] <= data_in;
                    size <= size + 1;
                end
            end else
            if (data_in_valid && read_ready) begin
                data_out <= nums[7:0];
                case (size)
                    4'd0: nums <= {56'd0, data_in};
                    4'd1: nums <= {56'd0, data_in};
                    4'd2: nums <= {48'd0, data_in, nums[15:8]};
                    4'd3: nums <= {40'd0, data_in, nums[23:8]};
                    4'd4: nums <= {32'd0, data_in, nums[31:8]};
                    4'd5: nums <= {24'd0, data_in, nums[39:8]};
                    4'd6: nums <= {16'd0, data_in, nums[47:8]};
                    4'd7: nums <= {8'd0, data_in, nums[55:8]};
                    4'd8: nums <= {data_in, nums[63:8]};
                    default: nums = nums;
                endcase
                size <= (size == 4'd0) ? 1 : size;
            end
        end
    end
endmodule