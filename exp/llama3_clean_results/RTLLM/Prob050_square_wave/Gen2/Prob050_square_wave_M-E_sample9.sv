module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [15:0] phase_accumulator; // Using a larger accumulator to allow for higher precision

always @(posedge clk) begin
    phase_accumulator <= phase_accumulator + 1;
    
    if (phase_accumulator >= (16'd65536 / freq)) begin
        wave_out <= ~wave_out;
        phase_accumulator <= 0;
    end
end

initial begin
    phase_accumulator = 0;
    wave_out = 0;
end

endmodule