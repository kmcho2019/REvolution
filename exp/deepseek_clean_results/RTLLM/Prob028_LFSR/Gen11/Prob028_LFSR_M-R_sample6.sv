module LFSR (
    input clk,            // Clock input
    input rst,            // Active high reset
    output reg [3:0] out  // 4-bit output
);

// Feedback calculation using continuous assignment
wire feedback = ~(out[3] ^ out[2]);

// State update logic
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;  // Reset to zero as specified
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule