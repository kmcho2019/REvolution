module TopModule(in1, in2, out);
    input in1;
    input in2;
    output out;

    // Directly implement the AND operation with inverted in2
    assign out = in1 & ~in2;

endmodule