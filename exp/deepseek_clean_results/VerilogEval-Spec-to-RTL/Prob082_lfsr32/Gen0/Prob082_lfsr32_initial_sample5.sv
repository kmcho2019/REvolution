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
        // Calculate feedback (XOR of taps with LSB)
        // Note: Verilog uses 0-based indexing, so taps are at 31, 21, 1, 0
        // (original spec was 1-based: 32, 22, 2, 1)
        q <= {q[0] ^ q[31] ^ q[21] ^ q[1] ^ q[0], q[31:1]};
    end
end

endmodule