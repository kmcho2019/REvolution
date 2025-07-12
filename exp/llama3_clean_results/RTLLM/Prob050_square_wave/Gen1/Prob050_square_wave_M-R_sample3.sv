module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 0;
reg prev_wave_out = 0;

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 0;
        prev_wave_out <= ~prev_wave_out;
    end else begin
        count <= count + 1;
    end
end

assign wave_out = prev_wave_out;

endmodule