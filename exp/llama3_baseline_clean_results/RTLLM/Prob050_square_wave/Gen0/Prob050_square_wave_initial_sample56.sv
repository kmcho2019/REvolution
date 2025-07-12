module square_wave (
    input clk,        // Clock signal
    input [7:0] freq, // Frequency control
    output reg wave_out // Square wave output signal
);

reg [7:0] count; // Counter register

always @ (posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset count and toggle wave_out when count reaches freq - 1
        count <= 0;
        wave_out <= ~wave_out; // Toggle wave_out
    end else begin
        // Increment count if it hasn't reached freq - 1
        count <= count + 1;
    end
end

// Initialize count to 0 and wave_out to 0 at power-up or reset
initial begin
    count <= 0;
    wave_out <= 0;
end

endmodule