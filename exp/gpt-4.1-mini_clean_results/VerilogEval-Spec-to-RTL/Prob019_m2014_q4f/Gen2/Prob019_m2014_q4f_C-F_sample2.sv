module TopModule (
    input  in1,
    input  in2,
    output out
);
    // AND gate with bubble on in2: out = in1 & ~in2
    // Equivalent to: out = ~(~in1 | in2)  (NAND of ~in1 and in2)
    assign out = in1 & ~in2;
endmodule