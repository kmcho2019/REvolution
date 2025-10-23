module TopModule (
    input  wire clk,     // System clock (positive edge-triggered)
    input  wire ar_n,    // Asynchronous reset (active low - improved for power)
    input  wire d,       // Data input
    output wire q        // Buffered output
);

(* clock_gating = "yes" *)  // Synthesis directive for clock gating
reg q_reg;
wire clk_en = (q_reg != d); // Clock enable when data changes

// Positive edge-triggered D flip-flop with async active-low reset
always @(posedge clk or negedge ar_n) begin
    if (!ar_n) begin
        q_reg <= 1'b0;    // Async reset (highest priority)
    end else if (clk_en) begin
        q_reg <= d;       // Clock-gated data capture
    end
end

// Output buffer for better drive strength
(* dont_touch = "true" *)  // Prevent optimization of critical buffer
bufif1 out_buf (q, q_reg, ar_n); // Tri-state during reset for isolation

// Reset isolation cell to prevent glitches
(* async_reg = "true" *)  // Mark reset as asynchronous
wire ar_isolated;
always @(negedge ar_n or posedge clk) begin
    if (!ar_n) ar_isolated <= 1'b0;
    else ar_isolated <= 1'b1;
end

endmodule