module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // Phase accumulator (16-bit for better frequency resolution)
    reg [15:0] phase_acc = 0;
    
    // Frequency control word (scaled to accumulator width)
    wire [15:0] freq_word = {freq, 8'b0};  // freq * 256
    
    always @(posedge clk) begin
        if (freq == 0) begin
            phase_acc <= 16'b0;
            wave_out <= 1'b0;
        end else begin
            phase_acc <= phase_acc + freq_word;
            wave_out <= phase_acc[15];  // MSB is our square wave
        end
    end

endmodule