module TopModule (
    input  in1,
    input  in2,
    output out
);

wire in2_inv;

not U_not (in2_inv, in2);
and U_and (out, in1, in2_inv);

endmodule