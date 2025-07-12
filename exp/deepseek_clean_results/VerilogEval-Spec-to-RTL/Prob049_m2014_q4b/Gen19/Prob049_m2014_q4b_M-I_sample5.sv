module TopModule (
    input  wire clk,       // Positive edge-triggered clock
    input  wire ar,        // Asynchronous reset (active high by default)
    input  wire d,         // Data input
    output wire q          // Buffered output
);

parameter RESET_POLARITY = 1'b1; // 1=active high, 0=active low

reg  q_reg;                // Flip-flop storage
wire clk_en = (q_reg != d); // Clock enable when data changes

// Positive edge-triggered D flip-flop with async reset and clock gating
always @(posedge clk or posedge ar) begin
    if (ar == RESET_POLARITY) q_reg <= 1'b0;  // Async reset
    else if (clk_en)          q_reg <= d;     // Clock-gated update
end

// Output buffer for better drive strength
assign q = q_reg;

endmodule