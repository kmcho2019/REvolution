module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Explicit feedback wire for clarity
wire feedback_bit = ~Q[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low synchronous reset
    end else begin
        // Optimized shift operation with clear bit positions
        Q <= {feedback_bit, Q[63:1]};  // MSB gets inverted LSB
    end
end

endmodule