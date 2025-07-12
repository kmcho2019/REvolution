module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [15:0] phase_accumulator;  // Phase accumulator register
reg [7:0] phase_increment;  // Phase increment register

// Calculate phase increment value
always @(*) begin
    phase_increment = (1 << freq);
end

// Update phase accumulator
always @(posedge clk) begin
    phase_accumulator <= phase_accumulator + phase_increment;
    if (phase_accumulator > 16'h7FFF) begin
        phase_accumulator <= 0;
        wave_out <= ~wave_out;
    end
end

endmodule