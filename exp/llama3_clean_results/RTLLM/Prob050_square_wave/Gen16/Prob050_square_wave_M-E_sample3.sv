module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] counter;  // Counter register
reg wave_out_reg;  // Register to store the wave_out signal

// Phase-Locked Loop (PLL) implementation
always @(posedge clk) begin
    if (counter == freq - 1) begin
        wave_out_reg <= ~wave_out_reg;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

// Assign the wave_out signal
assign wave_out = wave_out_reg;

endmodule