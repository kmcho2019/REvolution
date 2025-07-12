module TopModule (
    input in1,
    input in2,
    output out
);
    // MUX implementation of AND with bubble on in2
    assign out = in1 ? ~in2 : 1'b0;
endmodule