module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Internal register to track cycles between wave toggles

always @(posedge clk) begin
    if (count == freq - 1) begin
        count <= 0;  // Reset count to 0
        wave_out <= ~wave_out;  // Toggle wave_out
    end else begin
        count <= count + 1;  // Increment count
    end
end

initial wave_out = 0;  // Initialize wave_out to 0 to prevent it from being undefined at startup

endmodule