module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [15:0] phase_accumulator = 0;  // 16-bit for better frequency resolution

    always @(posedge clk) begin
        if (freq == 0) begin
            // Handle special case when freq is 0
            wave_out <= 0;
            phase_accumulator <= 0;
        end else begin
            // Accumulate phase
            phase_accumulator <= phase_accumulator + {8'b0, freq};
            
            // Output is MSB of accumulator (auto-overflow creates square wave)
            wave_out <= phase_accumulator[15];
        end
    end

endmodule