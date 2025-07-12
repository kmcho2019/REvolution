module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register

always @(posedge clk) begin
    count <= (count == freq - 1) ? 0 : count + 1;
    wave_out <= (count == freq - 1) ? ~wave_out : wave_out;
end

endmodule