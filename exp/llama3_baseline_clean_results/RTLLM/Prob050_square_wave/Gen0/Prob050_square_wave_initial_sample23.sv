module square_wave(
    input       clk,  // Clock signal
    input [7:0] freq,  // Frequency control
    output      wave_out  // Square wave output signal
    );

reg [7:0] count;  // Counter register
reg       wave_out_reg;  // Register to hold wave_out value

// Initialize wave_out and count registers
initial begin
    wave_out_reg = 1'b0;
    count = 8'b0;
end

// On each rising edge of clk, increment count and check if it's time to toggle wave_out
always @(posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset count and toggle wave_out
        count <= 8'b0;
        wave_out_reg <= ~wave_out_reg;
    end else begin
        // Increment count
        count <= count + 1;
    end
end

// Assign wave_out_reg to wave_out output
assign wave_out = wave_out_reg;

endmodule