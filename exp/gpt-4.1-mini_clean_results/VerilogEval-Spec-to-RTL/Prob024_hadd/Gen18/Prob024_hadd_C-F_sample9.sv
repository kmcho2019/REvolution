module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

    // Half Adder implementation:
    // sum = XOR of inputs
    // cout = AND of inputs
    assign sum = a ^ b;
    assign cout = a & b;

    /*
    // Optional structural implementation:
    // Uncomment to instantiate gate modules for clarity or educational purposes
    
    // XORGate xor_inst (
    //     .x(a),
    //     .y(b),
    //     .z(sum)
    // );

    // ANDGate and_inst (
    //     .x(a),
    //     .y(b),
    //     .z(cout)
    // );
    */

endmodule

// Simple XOR gate module for optional structural use
module XORGate (
    input  x,
    input  y,
    output z
);
    assign z = x ^ y;
endmodule

// Simple AND gate module for optional structural use
module ANDGate (
    input  x,
    input  y,
    output z
);
    assign z = x & y;
endmodule