module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

// Phase accumulator register
reg [15:0] phase_accum;

// Threshold for toggling the wave_out signal
reg [15:0] threshold;

// Initialize threshold to half of the maximum phase value
initial threshold = 16'd32767;

// Always block to handle clock edge and update phase_accum
always @(posedge clk) begin
    // Calculate phase increment based on the input frequency
    reg [15:0] phase_increment;
    phase_increment = freq;

    // Accumulate phase
    phase_accum <= phase_accum + phase_increment;

    // Toggle wave_out when phase_accum exceeds the threshold
    if (phase_accum > threshold) begin
        wave_out <= ~wave_out;
        phase_accum <= 0; // Reset phase_accum
    end
end

// Initial block to set initial values for wave_out and phase_accum
initial begin
    wave_out = 0;
    phase_accum = 0;
end

endmodule