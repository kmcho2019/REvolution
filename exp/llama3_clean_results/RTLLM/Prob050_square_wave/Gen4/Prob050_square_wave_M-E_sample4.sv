module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [15:0] phase_accumulator; // 16-bit phase accumulator
reg [15:0] threshold; // Threshold value for toggling wave_out

always @(posedge clk) begin
    phase_accumulator <= phase_accumulator + 1; // Increment phase accumulator
    if (phase_accumulator >= threshold) begin
        wave_out <= ~wave_out; // Toggle wave_out when threshold is reached
        phase_accumulator <= 0; // Reset phase accumulator
    end
end

always @(*) begin
    // Calculate threshold value based on input frequency
    threshold = (1 << 8) - freq;
end

initial begin
    wave_out = 0;
    phase_accumulator = 0;
end

endmodule