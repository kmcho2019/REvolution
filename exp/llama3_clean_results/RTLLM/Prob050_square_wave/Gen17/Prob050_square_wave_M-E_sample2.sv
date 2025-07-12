module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg wave_out_temp;  // Temporary wave output

// Phase detector
always @(posedge clk) begin
    if (count == 0) begin
        wave_out_temp <= ~wave_out;
    end
end

// Loop filter
always @(posedge clk) begin
    if (count < freq) begin
        count <= count + 1;
    end else begin
        count <= 0;
        wave_out <= wave_out_temp;
    end
end

// Voltage-controlled oscillator (VCO)
always @(posedge clk) begin
    wave_out_temp <= ~wave_out_temp;
end

endmodule