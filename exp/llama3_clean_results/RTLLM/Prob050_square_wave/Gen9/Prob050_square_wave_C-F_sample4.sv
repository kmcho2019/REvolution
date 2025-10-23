module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;

always @(posedge clk) begin
    count <= (count == freq) ? 8'd0 : (count + 8'd1);
    wave_out <= (count == (freq / 2)) ? 1'b1 : 1'b0;
end

endmodule