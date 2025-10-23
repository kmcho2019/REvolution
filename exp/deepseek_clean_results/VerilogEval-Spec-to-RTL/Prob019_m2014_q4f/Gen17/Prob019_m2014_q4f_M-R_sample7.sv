module TopModule (
    input in1,
    input in2,
    output out
);
    // Direct implementation combining NOT and AND operations
    assign out = in1 & ~in2;
endmodule