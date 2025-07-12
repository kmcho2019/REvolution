module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // 4-bit LFSR state output
);

// Feedback is XOR of bits 3 and 2, then inverted
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;    // Initialize to non-zero state
    end
    else begin
        // Shift left and insert inverted XOR feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule