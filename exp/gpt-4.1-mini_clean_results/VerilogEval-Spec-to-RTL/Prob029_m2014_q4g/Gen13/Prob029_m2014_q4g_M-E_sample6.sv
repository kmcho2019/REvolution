module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    wire xor12;
    wire xnor12;

    assign xor12 = in1 ^ in2;
    assign xnor12 = ~xor12;
    assign out = xnor12 ^ in3;

endmodule