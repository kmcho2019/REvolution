module LFSR (
    input clk,
    input rst,
    input load,          // New control signal for parallel load
    input [3:0] seed,    // New seed input for deterministic initialization
    output reg [3:0] out // Current state output
);

// Galois configuration with taps at bits 3 and 1
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Initialize to non-zero state (better for LFSR operation)
    end
    else if (load) begin
        out <= seed;     // Parallel load capability
    end
    else begin
        // Galois-style feedback with XOR gates in the middle
        out <= {out[2] ^ out[0], out[3], out[1] ^ out[0], out[0]};
    end
end

endmodule