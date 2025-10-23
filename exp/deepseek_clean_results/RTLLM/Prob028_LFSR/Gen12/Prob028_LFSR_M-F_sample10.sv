module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // Current LFSR state
);

// Feedback taps at bits 3 and 2 (XOR then invert as specified)
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;      // Initialize to non-zero state
    end
    else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule