module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

wire [4:0] bits;
assign bits = {a, b, c, d, e};

integer i, j;
genvar k;
generate
    for (k = 0; k < 25; k++) begin
        integer ii, jj;
        assign ii = k / 5;
        assign jj = k % 5;
        assign out[24-k] = (bits[ii] == bits[jj]);
    end
endgenerate

endmodule