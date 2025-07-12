module TopModule (
    input  in1,
    input  in2,
    output out
);

wire inv_in2;

not U_NOT (inv_in2, in2);
and U_AND (out, in1, inv_in2);

endmodule