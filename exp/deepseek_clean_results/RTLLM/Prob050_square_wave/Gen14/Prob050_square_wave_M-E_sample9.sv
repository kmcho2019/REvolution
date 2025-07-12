module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit phase accumulator for better frequency resolution
    reg [15:0] phase_acc = 0;
    wire [15:0] freq_ext = {8'b0, freq}; // Zero-extend frequency control

    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;
            phase_acc <= 0;
        end else begin
            // Phase accumulation (wraps automatically)
            phase_acc <= phase_acc + freq_ext;
            // Output is MSB of phase accumulator
            wave_out <= phase_acc[15];
        end
    end

endmodule