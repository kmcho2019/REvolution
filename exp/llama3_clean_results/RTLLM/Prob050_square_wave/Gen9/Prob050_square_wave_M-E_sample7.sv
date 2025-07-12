module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] counter;  // Counter register
reg phase_detector_out;  // Phase detector output
reg [7:0] loop_filter_out;  // Loop filter output
reg vco_out;  // VCO output

// Phase detector
always @(posedge clk) begin
    if (counter == freq) begin
        phase_detector_out <= ~phase_detector_out;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

// Loop filter
always @(posedge clk) begin
    loop_filter_out <= loop_filter_out + (phase_detector_out ? 1 : -1);
end

// Voltage-Controlled Oscillator (VCO)
always @(posedge clk) begin
    if (loop_filter_out > 0) begin
        vco_out <= ~vco_out;
    end
end

// Square wave generation
always @(posedge vco_out) begin
    wave_out <= ~wave_out;
end

endmodule