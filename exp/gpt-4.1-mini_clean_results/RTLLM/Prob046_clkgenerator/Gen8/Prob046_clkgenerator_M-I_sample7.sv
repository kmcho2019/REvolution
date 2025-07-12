module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

// Calculate half period with minimum of 1 time unit to avoid zero delay.
// This assumes PERIOD is in simulation time units (e.g., ns).
localparam integer HALF_PERIOD = (PERIOD < 2) ? 1 : (PERIOD / 2);

initial begin
    clk = 1'b0;
end

// Simulation-only clock toggling every HALF_PERIOD units.
always begin
    #HALF_PERIOD clk <= ~clk;
end

endmodule