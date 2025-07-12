module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [15:0] phase_accumulator = 16'd0;

always @(posedge clk) begin
    phase_accumulator <= phase_accumulator + {8'd0, freq};
    wave_out <= phase_accumulator[15]; // most significant bit determines the output
end

endmodule