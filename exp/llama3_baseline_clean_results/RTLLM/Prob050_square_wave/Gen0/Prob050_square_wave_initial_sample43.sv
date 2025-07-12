module square_wave(
    input clk,
    input [7:0] freq,
    output wave_out
);

reg [7:0] count;
reg wave_out_reg;

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 0;
        wave_out_reg <= ~wave_out_reg; // Toggle wave_out on frequency match
    end else begin
        count <= count + 1; // Increment count on every clock cycle
    end
end

assign wave_out = wave_out_reg; // Continuous assignment for wave_out

initial begin
    count = 0;
    wave_out_reg = 1'b0; // Initialize wave_out to 0
end

endmodule