module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset, set q to 32'h1
        q <= 32'h1;
    end else begin
        // Compute the next state of the LFSR
        reg [31:0] next_q;
        next_q[31] <= q[30] ^ q[0]; // Tap at position 32 (index 31)
        next_q[30:22] <= q[29:21]; // No taps in this range, just shift right
        next_q[21] <= q[20] ^ q[0]; // Tap at position 22 (index 21)
        next_q[20:2] <= q[19:1]; // No taps in this range, just shift right
        next_q[1] <= q[0] ^ q[0]; // Tap at position 2 (index 1)
        next_q[0] <= q[31] ^ q[0]; // Tap at position 1 (index 0) and shift right
        q <= next_q;
    end
end

endmodule