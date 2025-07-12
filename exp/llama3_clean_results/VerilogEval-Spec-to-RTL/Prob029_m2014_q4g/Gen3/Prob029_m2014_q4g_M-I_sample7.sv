module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Using bitwise operators for efficiency and simplicity
assign out = ~(in1 ^ in2) ^ in3;

endmodule