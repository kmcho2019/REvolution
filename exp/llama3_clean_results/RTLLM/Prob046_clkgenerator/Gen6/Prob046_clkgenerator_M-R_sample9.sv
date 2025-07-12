module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [7:0] time; // Variable to track time
reg clk_int; // Internal clock signal
reg reset; // Reset signal

always @(*) begin
    // Initialize clock and time on reset
    if (reset) begin
        time <= 0;
        clk_int <= 1'b0;
    end else if (time < (PERIOD / 2)) begin
        // Increment time until half period
        time <= time + 1;
        clk_int <= 1'b0;
    end else if (time < PERIOD) begin
        // Increment time until full period
        time <= time + 1;
        clk_int <= 1'b1;
    end else begin
        // Reset time and toggle clock
        time <= 0;
        clk_int <= ~clk_int;
    end
end

assign clk = clk_int; // Assign internal clock to output
assign reset = 1'b0; // Deassert reset after initialization

initial begin
    #0 reset = 1'b1; // Assert reset at time 0
    #1 reset = 1'b0; // Deassert reset after 1 time unit
end

endmodule