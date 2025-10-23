module TopModule (
    output zero
);
    // Most efficient implementation: direct constant assignment
    // Equivalent to an AND gate with one input permanently 0
    assign zero = 1'b0;
endmodule