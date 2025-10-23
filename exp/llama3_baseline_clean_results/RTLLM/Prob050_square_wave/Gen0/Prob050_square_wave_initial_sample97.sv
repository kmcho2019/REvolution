module square_wave(
    input       clk,
    input [7:0] freq,
    output      wave_out
);

reg [7:0] count; // Counter register
reg       wave_out_reg; // Register to hold the wave_out value

assign wave_out = wave_out_reg; // Continuous assignment for output

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset count and toggle wave_out when count reaches freq - 1
        count <= 0;
        wave_out_reg <= ~wave_out_reg; // Toggle wave_out
    end else begin
        // Increment count if it hasn't reached freq - 1
        count <= count + 1;
    end
end

initial begin
    count <= 0; // Initialize count to 0
    wave_out_reg <= 0; // Initialize wave_out to 0
end

endmodule