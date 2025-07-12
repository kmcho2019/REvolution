module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit phase accumulator for better frequency resolution
    reg [15:0] phase_acc = 0;
    
    always @(posedge clk) begin
        if (freq == 0) begin
            phase_acc <= 16'd0;
            wave_out <= 1'b0;
        end else begin
            // Accumulate phase (frequency control word is left-shifted for better resolution)
            phase_acc <= phase_acc + {freq, 8'b0};
            
            // Output is MSB of accumulator (natural square wave)
            wave_out <= phase_acc[15];
        end
    end

endmodule