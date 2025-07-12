module LFSR (
    input clk,
    input rst,
    input en,        // Optional enable signal
    output reg [3:0] out
);

wire feedback;

// Feedback taps bits 3 and 0 (x^4 + x^3 + 1 polynomial)
assign feedback = out[3] ^ out[0];

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001; // Initialize to non-zero value
    end else if (en) begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule