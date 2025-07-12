module TopModule (
    input  in1,
    input  in2,
    output out
);

wire not_in2;
not u_not_in2(not_in2, in2);
and u_and(out, in1, not_in2);

endmodule