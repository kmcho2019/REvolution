module TopModule (
    input in1,
    input in2,
    output out
);
    // MUX-based implementation
    assign out = in1 ? ~in2 : 1'b0;
endmodule