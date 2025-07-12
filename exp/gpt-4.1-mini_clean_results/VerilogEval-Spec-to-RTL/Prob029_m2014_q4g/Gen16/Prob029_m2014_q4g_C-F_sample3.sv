module XNOR2 (
    input  a,
    input  b,
    output y
);
    assign y = ~(a ^ b);
endmodule

module XOR2 (
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule

module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // Directly implement the logic expression without instantiating gate modules
    assign out = (~(in1 ^ in2)) ^ in3;
endmodule