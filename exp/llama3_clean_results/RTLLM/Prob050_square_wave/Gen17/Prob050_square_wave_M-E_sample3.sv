module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [15:0] phase = 16'd0; // phase accumulator
reg [7:0] threshold = 8'd0; // threshold value derived from freq

always @(posedge clk) begin
    phase <= phase + freq; // increment phase by freq on each clock cycle
    if (phase > 16'd255) begin // toggle wave_out when phase exceeds threshold
        wave_out <= ~wave_out; // toggle output square wave
        phase <= 16'd0; // reset phase accumulator
    end
end

endmodule