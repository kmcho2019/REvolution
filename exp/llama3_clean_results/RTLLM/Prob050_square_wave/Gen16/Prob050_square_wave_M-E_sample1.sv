module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] phase_error;  // Phase error register
reg [7:0] vco_control;  // VCO control register
reg [7:0] vco_count;  // VCO counter register

// Phase detector
always @(posedge clk) begin
    if (wave_out == 1'b1) begin
        phase_error <= phase_error - 1;
    end else begin
        phase_error <= phase_error + 1;
    end
end

// Loop filter
always @(posedge clk) begin
    vco_control <= vco_control + (phase_error > freq) ? 1 : -1;
end

// VCO
always @(posedge clk) begin
    if (vco_count == vco_control) begin
        wave_out <= ~wave_out;
        vco_count <= 0;
    end else begin
        vco_count <= vco_count + 1;
    end
end

endmodule