module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

    // Half Adder: sum is XOR of inputs, carry out is AND of inputs
    assign sum = a ^ b;
    assign cout = a & b;

    /* 
    // Optional: Structural implementation for clarity or educational purposes
    // Uncomment below to instantiate gates explicitly instead of direct assign

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

// Simple XOR gate module - reusable if structural instantiation preferred
module XORGate (
    input  x,
    input  y,
    output z
);
    assign z = x ^ y;
endmodule

// Simple AND gate module - reusable if structural instantiation preferred
module ANDGate (
    input  x,
    input  y,
    output z
);
    assign z = x & y;
endmodule