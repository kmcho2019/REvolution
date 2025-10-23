module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg temp_wave_out;

always @(posedge clk) begin
    if (count == freq) begin
        count <= 8'd0;
        temp_wave_out <= ~wave_out;
    end else begin
        count <= count + 8'd1;
    end
end

always @(*) begin
    wave_out <= temp_wave_out;
end

endmodule