module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output q       // Output
);

reg q_reg = 1'b0;  // Internal register with initialization
wire q_next;       // Next state logic

// Combinational next state logic
assign q_next = r ? 1'b0 : d;

// Sequential behavior - clocked assignment
always @(posedge clk) begin
    q_reg <= q_next;
end

// Output assignment
assign q = q_reg;

endmodule