module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [15:0] phase_accumulator = 0;  // Double width for better frequency resolution

    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;
            phase_accumulator <= 0;
        end else begin
            phase_accumulator <= phase_accumulator + {8'b0, freq};
            wave_out <= phase_accumulator[15];  // MSB becomes our square wave
        end
    end

endmodule