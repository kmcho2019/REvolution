module clkgenerator #(
    parameter PERIOD = 10,
    parameter RESOLUTION = 8 // Resolution of the phase accumulator
)(
    output reg clk
);

reg [RESOLUTION-1:0] phase_accumulator = 0;

always @(posedge phase_accumulator[0]) begin
    if (phase_accumulator == (1 << (RESOLUTION - 1)) - 1) begin
        clk = ~clk;
    end
end

always #1 begin
    if (phase_accumulator == (1 << RESOLUTION) - 1) begin
        phase_accumulator <= 0;
    end else begin
        phase_accumulator <= phase_accumulator + 1;
    end
end

initial begin
    clk = 0; // Initialize the clock signal
end

endmodule