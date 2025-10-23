module TopModule(in1, in2, out);
    input in1;
    input in2;
    output out;

    // The original solution is already quite optimized.
    // This alternative formulation explicitly inverts in2 before the AND operation,
    // which might be optimized slightly differently by the synthesis tool.
    wire inverted_in2;
    assign inverted_in2 = ~in2;
    assign out = in1 & inverted_in2;

endmodule