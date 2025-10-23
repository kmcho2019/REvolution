module square_wave(
    input clk,  // Clock signal
    input [7:0] freq,  // Frequency control
    output reg wave_out  // Square wave output signal
    );

reg [15:0] phase_accumulator;  // Phase accumulator
reg wave_out_reg;  // Glitch-free toggle register

always @(posedge clk) begin
    phase_accumulator <= phase_accumulator + freq;
    if (phase_accumulator[15]) begin  // Overflow condition
        wave_out_reg <= ~wave_out_reg;  // Toggle wave_out
        phase_accumulator <= 0;  // Reset phase accumulator
    end
end

assign wave_out = wave_out_reg;  // Output assignment

initial begin
    phase_accumulator <= 0;
    wave_out_reg <= 0;  // Initialize wave_out to 0
end

endmodule