module TopModule (
    input clk,
    input reset,
    output reg [4:0] q = 1
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Fibonacci LFSR with left shift and taps at bit 0 and 2
        // Feedback polynomial: x^5 + x^3 + 1
        q <= {q[3:0], 1'b0} ^ (q[0] ? 5'b00101 : 5'b00000);
    end
end

endmodule