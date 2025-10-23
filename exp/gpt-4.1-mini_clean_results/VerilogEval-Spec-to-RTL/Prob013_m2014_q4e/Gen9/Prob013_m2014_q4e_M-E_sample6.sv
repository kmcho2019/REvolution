module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire or_out;

    or  u_or  (or_out, in1, in2);
    not u_not (out, or_out);

endmodule