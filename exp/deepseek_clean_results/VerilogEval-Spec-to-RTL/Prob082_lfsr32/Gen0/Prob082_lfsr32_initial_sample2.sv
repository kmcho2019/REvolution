module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Calculate the feedback (XOR of tap bits with LSB)
        // Note: Verilog uses 0-based indexing, so taps are at:
        // 32 -> q[31], 22 -> q[21], 2 -> q[1], 1 -> q[0]
        q <= {q[0] ^ q[31] ^ q[21] ^ q[1] ^ q[0], q[31:1]};
    end
end

endmodule