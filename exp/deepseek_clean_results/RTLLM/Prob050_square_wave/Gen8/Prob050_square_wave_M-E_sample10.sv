module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [15:0] phase_accumulator;  // 16-bit phase accumulator

    always @(posedge clk) begin
        phase_accumulator <= phase_accumulator + {8'b0, freq};  // Add frequency value
        wave_out <= phase_accumulator[15];  // Output MSB as square wave
    end

endmodule