module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] phase_acc = 8'd0; // Phase accumulator

always @(posedge clk) begin
    phase_acc <= phase_acc + freq; // Increment phase accumulator by frequency value
    
    // Toggle wave_out when phase accumulator crosses the midpoint
    if (phase_acc >= 8'd128) begin // 128 is the midpoint for an 8-bit phase accumulator
        wave_out <= ~wave_out;
        phase_acc <= phase_acc - 8'd256; // Wrap around to keep phase_acc within 8-bit range
    end
end

endmodule