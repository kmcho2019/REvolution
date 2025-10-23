module square_wave(
    input           clk,    // Clock signal
    input   [7:0]   freq,   // Frequency control
    output  reg     wave_out // Square wave output
);

reg [7:0] count; // Counter register

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset count and toggle wave_out
        count <= 0;
        wave_out <= ~wave_out; // Toggle wave_out
    end else begin
        count <= count + 1; // Increment count
    end
end

initial begin
    wave_out = 0; // Initialize wave_out to 0
    count = 0;    // Initialize count to 0
end

endmodule