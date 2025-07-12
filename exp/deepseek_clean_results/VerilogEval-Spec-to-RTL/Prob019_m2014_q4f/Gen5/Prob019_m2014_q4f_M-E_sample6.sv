module TopModule (
    input in1,
    input in2,
    output out
);
    // MUX implementation of in1 AND NOT in2
    assign out = in1 ? ~in2 : 1'b0;
endmodule