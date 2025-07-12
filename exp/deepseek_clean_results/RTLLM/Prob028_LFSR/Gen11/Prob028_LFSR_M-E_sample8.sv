module LFSR (
    input clk,
    input rst,
    input load,
    input [3:0] seed,
    output reg [3:0] out
);

// Feedback calculation (standard XOR of bits 3 and 0)
wire feedback = out[3] ^ out[0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize to 1 to prevent lock-up
        out <= 4'b0001;
    end else if (load) begin
        // Load external seed
        out <= seed;
    end else begin
        // Normal operation or self-reseeding
        if (out == 4'b0000) begin
            // Auto-reseed if we reach zero
            out <= 4'b0001;
        end else begin
            // Standard LFSR operation
            out <= {out[2:0], feedback};
        end
    end
end

endmodule