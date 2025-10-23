module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] phase = 0;

    always @(posedge clk) begin
        phase <= phase + freq;
        wave_out <= phase[7]; // MSB becomes our square wave
    end

endmodule