module LFSR (
    input clk,        // 1-bit clock
    input rst,        // 1-bit reset
    output reg [3:0] out  // 4-bit output
);

wire feedback;
assign feedback = ~(out[3] ^ out[2]);  // XOR bits 3 & 2, then invert

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Initialize to non-zero value
    end
    else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule