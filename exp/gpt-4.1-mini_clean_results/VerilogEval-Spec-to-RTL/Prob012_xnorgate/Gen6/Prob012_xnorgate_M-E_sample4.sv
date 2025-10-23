module TopModule(
    input a,
    input b,
    output out
);

wire and_ab, and_nAnB;

assign and_ab    = a & b;
assign and_nAnB  = (~a) & (~b);
assign out      = and_ab | and_nAnB;

endmodule