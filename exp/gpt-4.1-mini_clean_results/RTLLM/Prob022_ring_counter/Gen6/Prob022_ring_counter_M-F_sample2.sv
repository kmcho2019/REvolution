module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            // Circular left shift by 1 using bitwise operations
            out <= (out << 1) | (out[7]);
        end
    end

endmodule