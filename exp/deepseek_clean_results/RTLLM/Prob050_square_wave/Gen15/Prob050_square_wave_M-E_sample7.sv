module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit phase accumulator for better frequency resolution
    reg [15:0] phase_acc = 0;
    
    always @(posedge clk) begin
        if (freq == 0) begin
            phase_acc <= 0;
            wave_out <= 0;
        end else begin
            // Phase accumulation (frequency control)
            phase_acc <= phase_acc + {8'b0, freq};
            
            // Square wave output is MSB of accumulator
            wave_out <= phase_acc[15];
        end
    end

endmodule