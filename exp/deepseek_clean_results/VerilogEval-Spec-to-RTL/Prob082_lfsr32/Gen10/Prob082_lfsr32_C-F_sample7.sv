module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Synchronous reset to initial value
    end
    else begin
        // Galois LFSR with taps at positions 32, 22, 2, and 1
        q <= {
            q[0],                     // New MSB is old LSB
            q[31:23],                 // Untapped upper bits (shift right)
            q[22] ^ q[0],             // Tap at bit 22 (original position 23)
            q[21:3],                  // Middle untapped bits
            q[2] ^ q[0], q[1] ^ q[0]  // Taps at bits 2 and 1
        };
    end
end

endmodule