module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_edge;  // Internal signal that toggles on each clock edge
reg q_reg;     // Internal register to store the output

// Update the internal edge signal on each clock edge
always @(posedge clk or negedge clk)
    clk_edge <= ~clk_edge;

// Update the output register on the rising edge of the internal edge signal
always @(posedge clk_edge)
    q_reg <= d;

// Output the stored value
always @(*)
    q = q_reg;

endmodule