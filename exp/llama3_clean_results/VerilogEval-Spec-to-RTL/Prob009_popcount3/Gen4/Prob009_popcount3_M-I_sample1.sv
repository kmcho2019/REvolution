module TopModule(
    input  [2:0] in,
    output [1:0] out
);

wire sum1;
assign sum1 = in[0] + in[1];
assign out[0] = sum1 + in[2];
assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);

endmodule