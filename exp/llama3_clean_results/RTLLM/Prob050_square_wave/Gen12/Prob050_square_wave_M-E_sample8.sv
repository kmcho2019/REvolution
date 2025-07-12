module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] phase_error;  // Phase error register
reg [7:0] loop_filter;  // Loop filter register
reg [7:0] vco_control;  // VCO control register
reg wave_vco;  // VCO output signal

// Phase detector implementation
always @(posedge clk) begin
    if (wave_vco == 1'b1) begin
        phase_error <= phase_error + 1;
    end else begin
        phase_error <= phase_error - 1;
    end
end

// Loop filter implementation
always @(posedge clk) begin
    loop_filter <= loop_filter + (phase_error * freq);
end

// VCO implementation
always @(posedge clk) begin
    if (loop_filter > 128) begin
        wave_vco <= 1'b1;
    end else if (loop_filter < -128) begin
        wave_vco <= 1'b0;
    end else begin
        wave_vco <= ~wave_vco;
    end
end

// Square wave generation
always @(posedge clk) begin
    wave_out <= wave_vco;
end

endmodule