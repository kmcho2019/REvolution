module LFSR (
    input wire clk,        // Clock signal
    input wire rst,        // Active high reset
    output reg [3:0] out   // 4-bit output
);

// Feedback is XOR of bits 3 and 2, then inverted
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;    // Initialize to 0 on reset
    end
    else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule