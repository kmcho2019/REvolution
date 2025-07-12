module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg [7:0] phase;  // Phase register
reg wave_temp;  // Temporary wave signal

// Counter operation
always @(posedge clk) begin
    if (count == freq - 1) begin
        count <= 0;
        wave_temp <= ~wave_temp;
    end else begin
        count <= count + 1;
    end
end

// Phase-locked loop (PLL) implementation
always @(posedge clk) begin
    if (freq > 8'd128) begin
        phase <= phase + 1;
    end else if (freq < 8'd64) begin
        phase <= phase - 1;
    end
end

// Generate the output wave signal
assign wave_out = (count < freq / 2) ? wave_temp : ~wave_temp;

endmodule