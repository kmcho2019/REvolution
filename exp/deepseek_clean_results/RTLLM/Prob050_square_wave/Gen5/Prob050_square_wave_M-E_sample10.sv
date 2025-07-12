module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit phase accumulator for finer resolution
    reg [15:0] phase_acc = 16'h8000;  // Initialize to mid-range
    wire [15:0] phase_step = {8'b0, freq} << 7;  // Scale frequency to step size

    always @(posedge clk) begin
        if (freq == 0) begin
            // Special case: no output when freq=0
            wave_out <= 1'b0;
            phase_acc <= 16'h8000;
        end else begin
            // Continuous phase accumulation
            phase_acc <= phase_acc + phase_step;
            // Square wave is just the MSB of the phase accumulator
            wave_out <= phase_acc[15];
        end
    end

endmodule