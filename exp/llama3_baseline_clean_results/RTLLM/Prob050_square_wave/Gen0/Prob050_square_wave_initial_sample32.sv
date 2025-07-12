module square_wave(
    input clk,
    input [7:0] freq,
    output wave_out
);

reg [7:0] count; // Counter register
reg wave_out_reg; // Register to store the wave_out signal

// Initialize wave_out_reg to 0
initial begin
    wave_out_reg = 1'b0;
end

// Increment count on each rising edge of clk
always @(posedge clk) begin
    if (count == freq - 1) begin
        // Reset count and toggle wave_out when count reaches freq - 1
        count <= 8'd0;
        wave_out_reg <= ~wave_out_reg;
    end else begin
        // Increment count if it has not reached freq
        count <= count + 1;
    end
end

// Assign wave_out_reg to wave_out
assign wave_out = wave_out_reg;

endmodule