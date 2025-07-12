module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

// out_both[0 to 2] = in[i] & in[i+1], out_both[3] = 0
assign out_both[3] = 1'b0;
assign out_both[2:0] = in[2:0] & in[3:1];

// out_any[1 to 3] = in[i] | in[i-1], out_any[0] = 0
assign out_any[0] = 1'b0;
assign out_any[3:1] = in[3:1] | in[2:0];

// out_different[i] = in[i] ^ in[(i+1)%4], wrapping around
assign out_different = in ^ {in[0], in[3:1]};

endmodule