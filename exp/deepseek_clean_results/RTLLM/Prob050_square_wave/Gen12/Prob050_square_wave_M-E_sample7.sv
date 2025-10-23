module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit phase accumulator for better frequency resolution
    reg [15:0] phase_accumulator = 0;
    
    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;
            phase_accumulator <= 0;
        end else begin
            // Accumulate phase (frequency acts as phase increment)
            phase_accumulator <= phase_accumulator + {8'b0, freq};
            
            // MSB of accumulator becomes our square wave output
            wave_out <= phase_accumulator[15];
        end
    end

endmodule