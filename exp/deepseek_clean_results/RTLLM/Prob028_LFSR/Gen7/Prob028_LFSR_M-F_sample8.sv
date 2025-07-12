module LFSR (
    input wire clk,            // Clock input (1-bit)
    input wire rst,            // Active-high synchronous reset (1-bit)
    output reg [3:0] out      // Current LFSR state (4-bit)
);

// Internal feedback wire
wire feedback;

// Feedback calculation: XOR of bits 3 and 2, then inverted
assign feedback = ~(out[3] ^ out[2]);

// Main state register with synchronous reset
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;        // Initialize to zero on reset
    end
    else begin
        // Shift left and insert inverted feedback at LSB
        out <= {out[2:0], feedback};
    end
end

// Initialize for simulation (optional but good practice)
initial begin
    out = 4'b0000;
end

endmodule