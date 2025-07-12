module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    // 32-bit phase accumulator for high resolution
    reg [31:0] phase_accumulator;
    
    // Frequency tuning word calculation (scaled to 32 bits)
    wire [31:0] freq_tuning_word = {freq, 24'b0};
    
    always @(posedge clk) begin
        // Phase accumulation (wraps around naturally)
        phase_accumulator <= phase_accumulator + freq_tuning_word;
        
        // Square wave generation using MSB
        wave_out <= phase_accumulator[31];
    end

endmodule