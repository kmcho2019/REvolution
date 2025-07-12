// 2-input XOR gate
module Xor2Gate (
    input  x,
    input  y,
    output out
);
    assign out = x ^ y;
endmodule

// 2-input AND gate
module And2Gate (
    input  x,
    input  y,
    output out
);
    assign out = x & y;
endmodule

// 3-input OR gate
module Or3Gate (
    input  x,
    input  y,
    input  z,
    output out
);
    assign out = x | y | z;
endmodule

// TopModule implements out = a + b + c using a combination of XOR, AND, and OR gates
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire xor_ab, and_ab;
    wire xor_ab_c, and_xor_c;

    // Step 1: a XOR b
    Xor2Gate xor_gate1 (
        .x(a),
        .y(b),
        .out(xor_ab)
    );

    // Step 2: a AND b
    And2Gate and_gate1 (
        .x(a),
        .y(b),
        .out(and_ab)
    );

    // Step 3: (a XOR b) XOR c
    Xor2Gate xor_gate2 (
        .x(xor_ab),
        .y(c),
        .out(xor_ab_c)
    );

    // Step 4: (a XOR b) AND c
    And2Gate and_gate2 (
        .x(xor_ab),
        .y(c),
        .out(and_xor_c)
    );

    // Step 5: OR the three intermediate results
    Or3Gate or_gate (
        .x(xor_ab_c),
        .y(and_ab),
        .z(and_xor_c),
        .out(out)
    );
endmodule