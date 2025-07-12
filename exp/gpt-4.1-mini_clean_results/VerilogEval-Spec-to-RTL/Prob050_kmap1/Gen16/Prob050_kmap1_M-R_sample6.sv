module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Directly assign out as OR of inputs, minimizing logic levels and gates
    assign out = a | b | c;
endmodule