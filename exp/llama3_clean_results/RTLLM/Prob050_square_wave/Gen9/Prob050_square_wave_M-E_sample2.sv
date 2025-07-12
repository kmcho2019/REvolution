module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [15:0] phase_acc = 16'd0;

always @(posedge clk) begin
    phase_acc <= phase_acc + {8'd0, freq}; // Increment phase accumulator
    wave_out <= phase_acc[15]; // Generate square wave output
end

endmodule