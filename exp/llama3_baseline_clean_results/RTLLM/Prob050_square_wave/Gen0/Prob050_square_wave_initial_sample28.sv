module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count; // Counter register

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset count and toggle wave_out
        count <= 0;
        wave_out <= ~wave_out; // Toggle wave_out
    end else begin
        // Increment count
        count <= count + 1;
    end
end

// Initialize count and wave_out at startup
initial begin
    count <= 0;
    wave_out <= 0;
end

endmodule