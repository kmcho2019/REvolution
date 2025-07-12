module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] counter;  // Counter register
reg [7:0] vco_count;  // VCO counter register
reg wave_out_temp;  // Temporary wave output

// Phase detector
always @(posedge clk) begin
    if (counter == freq - 1) begin
        counter <= 0;
        wave_out_temp <= ~wave_out_temp;
    end else begin
        counter <= counter + 1;
    end
end

// VCO
always @(posedge clk) begin
    if (vco_count == freq - 1) begin
        vco_count <= 0;
        wave_out <= wave_out_temp;
    end else begin
        vco_count <= vco_count + 1;
    end
end

// Initialize wave_out_temp
initial begin
    wave_out_temp = 0;
end

endmodule