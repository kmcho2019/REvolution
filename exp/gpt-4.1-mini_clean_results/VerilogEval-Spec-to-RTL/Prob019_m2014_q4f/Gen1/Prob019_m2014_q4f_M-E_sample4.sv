module TopModule (
    input  in1,
    input  in2,
    output out
);

wire in2_n;

not U_NOT (.Y(in2_n), .A(in2));
and U_AND (.Y(out), .A(in1), .B(in2_n));

endmodule