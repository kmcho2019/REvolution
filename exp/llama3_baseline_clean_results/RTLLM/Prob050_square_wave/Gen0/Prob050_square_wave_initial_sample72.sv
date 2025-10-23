module square_wave(
    input clk,        // Input clock signal
    input [7:0] freq,  // Frequency control value
    output reg wave_out  // Output square wave signal
);

reg [7:0] count;  // Counter register to track cycles between wave toggles

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset the counter and toggle the wave_out signal
        count <= 0;
        wave_out <= ~wave_out;  // Toggle the wave_out signal
    end else begin
        // Increment the counter
        count <= count + 1;
    end
end

initial begin
    // Initialize the counter and wave_out signal
    count = 0;
    wave_out = 1'b0;  // Initialize wave_out to 0
end

endmodule