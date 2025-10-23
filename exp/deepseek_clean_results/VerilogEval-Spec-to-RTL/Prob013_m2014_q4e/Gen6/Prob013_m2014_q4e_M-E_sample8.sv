module TopModule (
    input in1,
    input in2,
    output out
);
    assign out = in1 ? 1'b0 : ~in2;
endmodule