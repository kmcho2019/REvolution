module square_wave(
    input clk,  // Clock signal
    input [7:0] freq,  // Frequency control
    output reg wave_out  // Square wave output signal
);

reg [7:0] count;  // Counter register

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 0;  // Reset counter
        wave_out <= ~wave_out;  // Toggle wave_out signal
    end else begin
        count <= count + 1;  // Increment counter
    end
end

initial begin
    count <= 0;  // Initialize counter
    wave_out <= 0;  // Initialize wave_out signal
end

endmodule