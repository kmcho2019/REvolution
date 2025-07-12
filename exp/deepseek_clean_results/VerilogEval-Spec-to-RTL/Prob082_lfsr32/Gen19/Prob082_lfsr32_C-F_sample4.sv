module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// 32-bit Galois LFSR with taps at positions 32, 22, 2, and 1
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Reset to initial seed
    end else begin
        q <= {
            q[0],               // Position 32 (MSB): tap
            q[31:23],           // Positions 31-23: shift
            q[22] ^ q[0],       // Position 22: tap
            q[21:3],            // Positions 21-3: shift
            q[2] ^ q[0],        // Position 2: tap
            q[1] ^ q[0]         // Position 1: tap
        };
    end
end

endmodule