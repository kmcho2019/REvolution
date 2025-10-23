module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [15:0] phase_acc = 16'd0; // Phase accumulator
reg [7:0] freq_reg = 8'd0; // Frequency control register
reg wave_out_reg = 1'b0; // Register for wave_out signal

always @(posedge clk) begin
    freq_reg <= freq; // Update frequency control register
    phase_acc <= phase_acc + freq_reg; // Increment phase accumulator
    if (phase_acc[15]) begin // Check if most significant bit is set (indicating phase wrap)
        wave_out_reg <= ~wave_out_reg; // Toggle wave_out signal
        phase_acc <= 16'd0; // Reset phase accumulator
    end
end

assign wave_out = wave_out_reg; // Assign wave_out signal

endmodule