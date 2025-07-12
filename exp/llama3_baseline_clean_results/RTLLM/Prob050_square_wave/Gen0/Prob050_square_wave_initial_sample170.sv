module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Internal counter register

// Initialize wave_out and count at the start
initial begin
    wave_out = 1'b0;  // Start with wave_out low
    count = 8'b0;     // Initialize count to 0
end

// Clocked always block to handle the counter and wave_out logic
always @(posedge clk) begin
    if (count == (freq - 1)) begin  // Check if count has reached freq - 1
        count <= 8'b0;               // Reset count to 0
        wave_out <= ~wave_out;       // Toggle wave_out
    end else begin
        count <= count + 1;          // Increment count if not at freq - 1
    end
end

endmodule