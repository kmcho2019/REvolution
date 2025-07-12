module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

wire or_bc;
assign or_bc = b || c;

assign q = or_bc || (a && ~d);

endmodule