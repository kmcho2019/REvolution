module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [15:0] phase_accumulator = 16'd0; // Increased width for finer control
reg [15:0] threshold = 16'd0;

always @(posedge clk) begin
    phase_accumulator <= phase_accumulator + 16'd1;
    if (phase_accumulator >= threshold) begin
        phase_accumulator <= 16'd0;
        wave_out <= ~wave_out;
    end
end

always @(*) begin
    // Calculate threshold based on frequency value
    // Higher frequency values result in lower thresholds, thus faster toggling
    threshold = 16'd65535 / (freq + 1'd1); // Adding 1 to avoid division by zero
end

endmodule