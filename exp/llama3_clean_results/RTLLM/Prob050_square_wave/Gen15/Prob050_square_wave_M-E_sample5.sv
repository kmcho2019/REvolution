module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg [7:0] phase;  // Phase register
reg [7:0] vco_control;  // VCO control register

// Phase detector
always @(posedge clk) begin
    if (count == freq - 1) begin
        phase <= phase + 1;
    end else begin
        phase <= phase;
    end
end

// Loop filter
always @(posedge clk) begin
    vco_control <= vco_control + (freq - phase);
end

// VCO
always @(posedge clk) begin
    if (vco_control >= 128) begin
        wave_out <= ~wave_out;
        vco_control <= 0;
    end else begin
        vco_control <= vco_control + 1;
    end
end

// Counter
always @(posedge clk) begin
    if (count == freq - 1) begin
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

endmodule