module TopModule (
    input in1,
    input in2,
    output out
);
    // MUX-based implementation of AND with inverted in2
    // out = in1 ? ~in2 : 1'b0
    assign out = in1 ? ~in2 : 1'b0;
endmodule