module square_wave(
    input clk,
    input [7:0] freq,
    output wave_out
);

reg [15:0] phase;  // Phase accumulator register
reg wave_out_reg;  // Register for wave_out to avoid inferred latch

always @(posedge clk) begin
    phase <= phase + {8'd1, freq};  // Increment phase accumulator
    if (phase[15]) begin  // Check for overflow
        wave_out_reg <= ~wave_out_reg;  // Toggle wave_out
        phase <= 0;  // Reset phase accumulator
    end
end

assign wave_out = wave_out_reg;  // Continuous assignment for output

endmodule