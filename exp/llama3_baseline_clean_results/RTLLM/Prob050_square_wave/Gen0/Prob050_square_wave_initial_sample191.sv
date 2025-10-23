module square_wave(
    input clk,        // Clock signal
    input [7:0] freq, // Frequency control
    output wave_out   // Square wave output
);

reg [7:0] count;     // Counter register
reg wave_out_reg;    // Register to store the current state of wave_out

// Initialize the count and wave_out_reg
initial begin
    count = 0;
    wave_out_reg = 1'b0;
end

always @ (posedge clk) begin
    // Increment the count on each rising edge of clk
    if (count < (freq - 1)) begin
        count = count + 1;
    end else begin
        // Reset the count and toggle the wave_out signal
        count = 0;
        wave_out_reg = ~wave_out_reg; // Toggle wave_out_reg
    end
end

// Assign the wave_out_reg to the output wave_out
assign wave_out = wave_out_reg;

endmodule