module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Reset to 1
    end
    else begin
        q <= {q[0] ^ q[4], q[3], q[2] ^ q[0], q[1], q[0]};
        // Correct Galois LFSR implementation:
        // q[4] <= q[0] ^ q[4] (feedback tap at position 5)
        // q[3] <= q[4] (shift)
        // q[2] <= q[3] ^ q[0] (tap at position 3)
        // q[1] <= q[2] (shift)
        // q[0] <= q[1] (shift)
    end
end

endmodule