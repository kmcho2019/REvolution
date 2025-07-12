module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;
wire clk_pulse;

// Create a delay element (in practice this would be properly sized)
reg clk_delayed;
always @(clk) clk_delayed <= #1 clk;  // Unit delay for simulation

// Generate pulses on both edges
assign clk_pulse = clk ^ clk_delayed;

// Single flip-flop triggered by pulses
always @(posedge clk_pulse) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule