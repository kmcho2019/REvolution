module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] val = {a,b,c,d};

// out_sop is 1 only for inputs 2(0010),7(0111),15(1111)
assign out_sop = (val == 4'd2) | (val == 4'd7) | (val == 4'd15);

// On the specified input domain, out_pos is simply the complement
assign out_pos = ~out_sop;

endmodule