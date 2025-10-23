module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [15:0] phase_accumulator;  // 16-bit accumulator for better frequency resolution

    always @(posedge clk) begin
        if (freq == 0) begin
            // Special case: zero frequency means constant output
            wave_out <= 1'b0;
        end else begin
            // Normal operation: phase accumulation
            phase_accumulator <= phase_accumulator + {8'b0, freq};
            // Output is MSB of accumulator
            wave_out <= phase_accumulator[15];
        end
    end

endmodule