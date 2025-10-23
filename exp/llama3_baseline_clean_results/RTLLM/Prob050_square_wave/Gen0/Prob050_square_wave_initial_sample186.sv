module square_wave(
    input  clk,
    input  [7:0] freq,
    output reg wave_out
);

reg [7:0] count; // Counter register

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        wave_out <= ~wave_out; // Toggle wave_out
        count <= 0; // Reset counter
    end else begin
        count <= count + 1; // Increment counter
    end
end

initial begin
    count <= 0; // Initialize counter to 0
    wave_out <= 1'b0; // Initialize wave_out to 0
end

endmodule