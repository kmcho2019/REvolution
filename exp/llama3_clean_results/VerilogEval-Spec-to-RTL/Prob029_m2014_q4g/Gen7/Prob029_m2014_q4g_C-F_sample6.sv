module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// The XNOR operation between in1 and in2 can be expressed as ~(in1 ^ in2)
// Then, the result of the XNOR operation is XORed with in3
// The overall expression can be simplified to ~(in1 ^ in2) ^ in3
assign out = ~(in1 ^ in2) ^ in3;

endmodule