module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // 4-bit LFSR state output
);

parameter RST_VAL = 4'b0001; // Parameter for reset value

// Feedback is XOR of bits 3 and 2, then inverted
wire feedback = ~(out[3] ^ out[2]);

always @(negedge clk) begin
    if (rst) begin
        out <= RST_VAL;    // Initialize to parameterized reset value
    end
    else begin
        // Shift left and insert inverted XOR feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule