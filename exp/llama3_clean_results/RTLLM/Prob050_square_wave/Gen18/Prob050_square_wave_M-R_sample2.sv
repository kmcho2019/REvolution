module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;

always @(posedge clk) begin
    if (count == freq) begin
        count <= 8'd0;
    end else begin
        count <= count + 8'd1;
    end
end

always @(posedge clk) begin
    if (count == freq) begin
        wave_out <= ~wave_out;
    end
end

endmodule