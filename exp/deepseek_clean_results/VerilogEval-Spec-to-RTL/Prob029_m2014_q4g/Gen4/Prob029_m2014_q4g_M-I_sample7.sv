module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    // Alternative implementation using XOR and NOT
    assign out = (~(in1 ^ in2)) ^ in3;

endmodule