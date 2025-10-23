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
        // Galois LFSR with taps at bits 31, 21, 1, and 0
        q <= {q[0] ^ q[31],  // New MSB (tap at 31)
              q[30:22],      // Normal shift (bits 30-22)
              q[21] ^ q[0],  // Tap at 21
              q[20:2],       // Normal shift (bits 20-2)
              q[1] ^ q[0],   // Tap at 1
              q[0] ^ q[0]    // Tap at 0 (always 0)
             };
    end
end

endmodule