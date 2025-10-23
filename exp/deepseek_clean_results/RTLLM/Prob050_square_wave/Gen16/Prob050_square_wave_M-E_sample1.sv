module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [15:0] phase_acc = 0;
    wire [15:0] phase_inc = {8'b0, freq} << 8;  // Scale frequency to phase increment

    always @(posedge clk) begin
        phase_acc <= phase_acc + phase_inc;
        wave_out <= phase_acc[15];  // Output the MSB which toggles at desired frequency
    end

endmodule