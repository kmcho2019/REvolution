module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

reg [7:0] count;  // Counter register
reg wave_out_reg;  // Register to hold the wave_out value

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 0;  // Reset count when it reaches freq
        wave_out_reg <= ~wave_out_reg;  // Toggle wave_out
    end else begin
        count <= count + 1;  // Increment count on each clock cycle
    end
end

assign wave_out = wave_out_reg;  // Assign the wave_out_reg to output wave_out

initial begin
    count = 0;  // Initialize count to 0
    wave_out_reg = 0;  // Initialize wave_out to 0
end

endmodule