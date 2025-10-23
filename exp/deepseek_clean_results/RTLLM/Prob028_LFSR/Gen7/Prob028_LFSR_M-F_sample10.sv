module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;

// Calculate feedback: XOR bits 3 and 2, then invert
assign feedback = ~(out[3] ^ out[2]);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to 0 on reset
    end else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule