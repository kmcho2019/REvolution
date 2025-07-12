module TopModule (
    input  in1,
    input  in2,
    output out
);

wire in2_inv;

inv U_INV (
    .I(in2),
    .O(in2_inv)
);

and U_AND (
    .I0(in1),
    .I1(in2_inv),
    .O(out)
);

endmodule