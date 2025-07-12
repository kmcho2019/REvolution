module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [15:0] phase_accumulator = 0;
    wire [15:0] phase_increment = {8'b0, freq} << 8;  // Scale frequency to 16-bit range

    always @(posedge clk) begin
        phase_accumulator <= phase_accumulator + phase_increment;
        wave_out <= phase_accumulator[15];  // MSB becomes square wave output
    end

endmodule