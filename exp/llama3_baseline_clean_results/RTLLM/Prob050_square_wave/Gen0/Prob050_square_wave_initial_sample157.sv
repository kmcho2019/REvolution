module square_wave(
    input clk,  // Clock signal that drives the module
    input [7:0] freq,  // Frequency control, specifying how often the square wave toggles
    output wave_out  // Square wave output signal
);

reg [7:0] count;  // Counter register used to track cycles between wave toggles
reg wave_out_reg;  // Register to hold the current state of the wave_out signal

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset the count and toggle the wave_out signal
        count <= 0;
        wave_out_reg <= ~wave_out_reg;  // Flip the wave_out signal
    end else begin
        // Increment the count
        count <= count + 1;
    end
end

assign wave_out = wave_out_reg;  // Assign the wave_out_reg to the output port wave_out

// Initialize the count and wave_out_reg
initial begin
    count = 0;
    wave_out_reg = 0;  // Initialize wave_out_reg to 0
end

endmodule