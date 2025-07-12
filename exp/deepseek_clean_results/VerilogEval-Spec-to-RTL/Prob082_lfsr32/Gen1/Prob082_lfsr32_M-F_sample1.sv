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
        // Galois LFSR implementation with taps at 32, 22, 2, and 1
        // (positions 31, 21, 1, and 0 in 0-based indexing)
        q <= {
            q[0] ^ q[31],       // New MSB (tap at 32)
            q[30:22],           // Normal shift for non-tap bits
            q[21] ^ q[0],       // Tap at 22
            q[20:2],            // Normal shift for non-tap bits
            q[1] ^ q[0],       // Tap at 2
            q[0]                // Tap at 1 (just shifted out)
        };
    end
end

endmodule