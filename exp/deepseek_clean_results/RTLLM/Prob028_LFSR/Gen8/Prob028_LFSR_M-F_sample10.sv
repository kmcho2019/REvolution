module LFSR (
    input clk,        // Clock input
    input rst,        // Active high reset
    output reg [3:0] out  // 4-bit LFSR output
);

// Feedback calculation: XOR of bits 3 and 2, then inverted
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;  // Synchronous reset
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule