module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] phase_accumulator;

    always @(posedge clk) begin
        phase_accumulator <= phase_accumulator + freq;
    end

    assign wave_out = phase_accumulator[7];  // MSB becomes square wave

endmodule