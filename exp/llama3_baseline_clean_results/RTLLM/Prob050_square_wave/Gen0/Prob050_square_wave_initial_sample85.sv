module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;

always @(posedge clk) begin
    if (freq == 0) begin
        // If freq is 0, keep wave_out unchanged
        wave_out <= wave_out;
    end else if (count == freq - 1) begin
        // Reset count and toggle wave_out when count reaches freq - 1
        count <= 0;
        wave_out <= ~wave_out;  // Toggle wave_out
    end else begin
        // Increment count on each clock cycle if it hasn't reached freq - 1
        count <= count + 1;
    end
end

initial begin
    // Initialize count to 0 and wave_out to 0
    count = 0;
    wave_out = 0;
end

endmodule