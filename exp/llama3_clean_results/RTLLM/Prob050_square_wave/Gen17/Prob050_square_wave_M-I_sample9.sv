module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register

always @(posedge clk) begin
    if (count == freq) begin
        wave_out <= ~wave_out;  // Toggle wave_out
        count <= 0;  // Reset count
    end else begin
        count <= count + 1;  // Increment count
    end
end

endmodule