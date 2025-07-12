module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire not_in2;
    not U1 (not_in2, in2);
    and U2 (out, in1, not_in2);
endmodule