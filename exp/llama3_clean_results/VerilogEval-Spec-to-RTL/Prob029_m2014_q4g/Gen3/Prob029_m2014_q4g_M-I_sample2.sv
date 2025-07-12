module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);
// Direct implementation of the required logic in a single line
assign out = ~(in1 ^ in2) ^ in3;
endmodule