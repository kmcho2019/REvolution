module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // XNOR-based even parity checker (more direct implementation)
    assign q = a ~^ b ~^ c ~^ d;

endmodule