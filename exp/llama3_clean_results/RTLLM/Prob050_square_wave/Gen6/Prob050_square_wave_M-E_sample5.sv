module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] delay;  // Delay register
wire [7:0] wave_temp;  // Temporary wave signal

// Ring oscillator implementation
always @(posedge clk) begin
    wave_out <= wave_temp[freq - 1];
end

// Generate the temporary wave signal
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        if (i == 0) begin
            assign wave_temp[i] = ~wave_out;
        end else begin
            assign wave_temp[i] = ~wave_temp[i - 1];
        end
    end
endgenerate

endmodule