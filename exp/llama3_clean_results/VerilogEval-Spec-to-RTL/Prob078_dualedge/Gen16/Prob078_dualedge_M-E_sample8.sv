module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signal for phase-shifted clock
reg phase_shifted_clk;

// Generate phase-shifted clock signal
always @(posedge clk or negedge clk) begin
    phase_shifted_clk <= ~clk;
end

// Single flip-flop with phase-shifted clock
always @(posedge phase_shifted_clk) begin
    q <= d;
end

endmodule