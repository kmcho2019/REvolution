module TopModule (
    input  in1,
    input  in2,
    output out
);

wire inv_in1;

not U_NOT (inv_in1, in1);
nor U_NOR (out, inv_in1, in2);

endmodule