module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] lut [15:0];

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else begin
        q <= lut[q];
    end
end

initial begin
    lut[0] = 4'd1;
    lut[1] = 4'd2;
    lut[2] = 4'd3;
    lut[3] = 4'd4;
    lut[4] = 4'd5;
    lut[5] = 4'd6;
    lut[6] = 4'd7;
    lut[7] = 4'd8;
    lut[8] = 4'd9;
    lut[9] = 4'd10;
    lut[10] = 4'd11;
    lut[11] = 4'd12;
    lut[12] = 4'd13;
    lut[13] = 4'd14;
    lut[14] = 4'd15;
    lut[15] = 4'd0;
end

endmodule