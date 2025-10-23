module LFSR (
    input wire clk,        // Clock signal
    input wire rst,        // Active high reset
    output reg [3:0] out   // 4-bit LFSR state
);

// Feedback calculation: XOR bits 3 and 2, then invert
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// State update logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;    // Initialize to zero on reset
    end else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule