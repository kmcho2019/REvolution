module LFSR (
    input clk,        // Clock input
    input rst,        // Active high reset
    output reg [3:0] out  // 4-bit LFSR output
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001;  // Initialize to non-zero to prevent lock
    end else begin
        // Shift left and insert inverted XOR of bits 3 and 2
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule