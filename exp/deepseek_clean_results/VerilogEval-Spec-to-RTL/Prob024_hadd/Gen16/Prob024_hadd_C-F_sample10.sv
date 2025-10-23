module XOR_Gate(
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

module AND_Gate(
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    XOR_Gate sum_gate(
        .a(a),
        .b(b),
        .out(sum)
    );
    
    AND_Gate cout_gate(
        .a(a),
        .b(b),
        .out(cout)
    );
endmodule