module TopModule (
    input  [3:0] x,
    output       f
);

localparam [15:0] LUT = 16'b1001011000001011;

assign f = LUT[x];

endmodule