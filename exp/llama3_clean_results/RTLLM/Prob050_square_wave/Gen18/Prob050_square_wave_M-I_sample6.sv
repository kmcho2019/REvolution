module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register

always @(posedge clk) begin
    if (count == freq - 1) begin
        wave_out <= ~wave_out;  // Toggle wave_out when count reaches freq - 1
        count <= 0;  // Reset count to 0
    end else begin
        count <= count + 1;  // Increment count by 1
    end
end

endmodule