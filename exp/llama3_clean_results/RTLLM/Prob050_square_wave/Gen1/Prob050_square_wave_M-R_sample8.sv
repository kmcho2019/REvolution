module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg [7:0] freq_reg;  // Register to store freq value

always @(posedge clk) begin
    if (count == freq_reg - 1) begin
        count <= 0;  // Reset counter
        wave_out <= ~wave_out;  // Toggle wave_out
    end else begin
        count <= count + 1;  // Increment counter
    end
end

always @(posedge clk) begin
    freq_reg <= freq;  // Update freq_reg with freq value
end

endmodule