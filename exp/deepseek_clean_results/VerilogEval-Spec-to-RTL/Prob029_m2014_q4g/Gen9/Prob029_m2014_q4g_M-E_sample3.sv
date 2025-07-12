module XNOR2 (
    input a,
    input b,
    output y
);
    assign y = ~(a ^ b);
endmodule

module XOR2 (
    input a,
    input b,
    output y
);
    assign y = a ^ b;
endmodule

module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    wire xnor_out;
    
    XNOR2 xnor_inst (
        .a(in1),
        .b(in2),
        .y(xnor_out)
    );
    
    XOR2 xor_inst (
        .a(xnor_out),
        .b(in3),
        .y(out)
    );
endmodule