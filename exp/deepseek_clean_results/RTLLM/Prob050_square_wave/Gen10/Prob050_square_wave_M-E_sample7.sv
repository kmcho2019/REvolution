module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // Phase accumulator (9 bits to handle overflow naturally)
    reg [8:0] phase_acc = 0;
    
    // Frequency Tuning Word (FTW) calculation
    // FTW = (desired_freq * 2^N) / f_clk, simplified for our case
    wire [8:0] ftw = {1'b0, freq};
    
    // Clock gating control (disable when output won't change)
    wire clk_enable = (freq != 0) && (phase_acc[8] || (freq != 8'hFF));
    
    always @(posedge clk) begin
        if (clk_enable) begin
            // Phase accumulation with automatic wrapping
            phase_acc <= phase_acc + ftw;
            
            // Square wave generation (toggle at phase overflow)
            wave_out <= phase_acc[8] ? ~wave_out : wave_out;
        end
        else if (freq == 0) begin
            wave_out <= 1'b0;  // Constant low for freq=0
        end
    end

endmodule