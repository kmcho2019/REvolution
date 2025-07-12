module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count; // Counter register

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 0; // Reset counter
        wave_out <= ~wave_out; // Toggle wave_out
    end else begin
        count <= count + 1; // Increment counter
    end
end

initial begin
    count = 0; // Initialize counter
    wave_out = 0; // Initialize wave_out
end

endmodule