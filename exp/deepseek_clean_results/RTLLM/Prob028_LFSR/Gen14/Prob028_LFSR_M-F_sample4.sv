module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

// Feedback calculation: XOR of bits 3 and 2, then inverted
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;  // Active high reset to zero
    end else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule