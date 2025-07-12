module square_wave(
    input clk,
    input [7:0] freq,
    output wave_out
);

reg [7:0] count; // Counter register
reg wave_out_reg; // Register to store the current state of wave_out

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 0; // Reset the counter
        wave_out_reg <= ~wave_out_reg; // Toggle wave_out
    end else begin
        count <= count + 1; // Increment the counter
    end
end

assign wave_out = wave_out_reg; // Assign wave_out_reg to wave_out

endmodule