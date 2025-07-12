module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count; // Internal counter register

always @(posedge clk) begin
    // Increment the counter on every rising edge of the clock
    if (count == (freq - 1)) begin
        // Reset the counter and toggle the wave_out when count reaches freq - 1
        count <= 0;
        wave_out <= ~wave_out; // Toggle wave_out
    end else begin
        // Simply increment the counter if it hasn't reached freq - 1
        count <= count + 1;
    end
end

initial begin
    // Initialize count to 0 and wave_out to 0
    count = 0;
    wave_out = 0;
end

endmodule