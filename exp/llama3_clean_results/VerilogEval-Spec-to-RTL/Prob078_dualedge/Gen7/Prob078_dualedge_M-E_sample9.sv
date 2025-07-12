module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_phase_shifted;  // Phase-shifted clock
reg q_int;  // Internal flip-flop output

// Clock phase-shifter (simple inverter)
always @(clk) begin
    clk_phase_shifted = ~clk;
end

// Dual-edge triggered flip-flop (using single flip-flop and phase-shifted clock)
always @(posedge clk or posedge clk_phase_shifted) begin
    q_int <= d;
end

// Output assignment
assign q = q_int;

endmodule