module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    // 16-bit phase accumulator for better frequency resolution
    reg [15:0] phase_accumulator;

    always @(posedge clk) begin
        // Continuous phase accumulation
        phase_accumulator <= phase_accumulator + {8'b0, freq};
        
        // Output is MSB of accumulator (auto-toggles at correct frequency)
        wave_out <= phase_accumulator[15];
    end

endmodule