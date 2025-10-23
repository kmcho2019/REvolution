module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg prev_wave_out = 1'b0;

always @(posedge clk) begin
    count <= (count == freq) ? 8'd0 : count + 8'd1;
end

always @(posedge clk) begin
    if (count == freq) begin
        wave_out <= ~wave_out;
    end else begin
        wave_out <= wave_out;
    end
end

endmodule