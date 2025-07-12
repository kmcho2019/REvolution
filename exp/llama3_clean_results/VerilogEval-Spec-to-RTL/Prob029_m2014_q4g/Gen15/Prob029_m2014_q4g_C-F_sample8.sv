module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);
// Direct computation of XNOR followed by XOR using efficient and readable operators
assign out = ~(in1 ^ in2) ^ in3;
endmodule