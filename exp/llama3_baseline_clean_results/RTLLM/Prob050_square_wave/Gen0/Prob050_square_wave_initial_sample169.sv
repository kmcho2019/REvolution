module square_wave(
    input clk,
    input [7:0] freq,
    output wave_out
);

reg [7:0] count; // Counter register
reg wave_out_reg; // Register to hold the output wave

assign wave_out = wave_out_reg;

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 0;
        wave_out_reg <= ~wave_out_reg; // Toggle wave_out
    end else begin
        count <= count + 1;
    end
end

initial begin
    count = 0;
    wave_out_reg = 0;
end

endmodule