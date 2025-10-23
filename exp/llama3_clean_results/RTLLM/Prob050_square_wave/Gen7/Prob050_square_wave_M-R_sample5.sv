module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register

always @(posedge clk) begin
    if (count == freq - 1) begin
        wave_out <= ~wave_out;  // Toggle output signal
        count <= 0;  // Reset counter
    end else begin
        count <= count + 1;  // Increment counter
    end
end

endmodule