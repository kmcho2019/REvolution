module square_wave(
    input clk,
    input [7:0] freq,
    output wave_out
);

reg [7:0] count;  // Counter register
reg wave_out_reg;  // Register for wave_out to avoid inferred latch
reg [7:0] freq_reg;  // Register to store freq value

always @(posedge clk) begin
    if (freq !== freq_reg) begin  // Check if freq has changed
        freq_reg <= freq;  // Update freq_reg
        count <= 0;  // Reset counter when freq changes
        wave_out_reg <= wave_out_reg;  // Maintain current state of wave_out
    end else if (count == freq_reg - 1) begin
        count <= 0;  // Reset counter
        wave_out_reg <= ~wave_out_reg;  // Toggle wave_out
    end else begin
        count <= count + 1;  // Increment counter
    end
end

assign wave_out = wave_out_reg;  // Continuous assignment for output

endmodule