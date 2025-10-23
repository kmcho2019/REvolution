module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire or_out;

    or  (or_out, in1, in2);  // OR gate primitive
    not (out, or_out);       // NOT gate primitive
endmodule