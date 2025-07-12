module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] bit_counter;
reg [7:0] data;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_counter <= 0;
        out_byte <= 8'b0;
        done <= 0;
    end
    else begin
        if (bit_counter == 0 && !in) begin
            bit_counter <= 1;
        end
        else if (bit_counter > 0 && bit_counter < 9) begin
            data <= {data[6:0], in};
            bit_counter <= bit_counter + 1;
        end
        else if (bit_counter == 9 && in) begin
            out_byte <= data;
            done <= 1;
            bit_counter <= 0;
        end
        else if (bit_counter == 9 && !in) begin
            bit_counter <= 9;
        end
    end
end

endmodule