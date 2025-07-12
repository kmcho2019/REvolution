module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [7:0] phase_accumulator; // Phase accumulator to track time
reg [7:0] threshold; // Threshold value for toggling clock
reg clk_int; // Internal clock signal

initial begin
    phase_accumulator = 0; // Initialize phase accumulator
    threshold = PERIOD / 2; // Calculate threshold value
    clk_int = 1'b0; // Initialize clock to 0
end

always @(posedge #1) begin // Increment phase accumulator every time unit
    phase_accumulator <= phase_accumulator + 1;
    if (phase_accumulator >= threshold) begin
        phase_accumulator <= 0; // Reset phase accumulator
        clk_int <= ~clk_int; // Toggle clock
    end
end

assign clk = clk_int; // Assign internal clock to output

endmodule