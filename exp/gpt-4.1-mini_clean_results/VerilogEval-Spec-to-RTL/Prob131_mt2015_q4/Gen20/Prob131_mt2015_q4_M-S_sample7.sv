// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: z matches waveform given inputs x and y
// B outputs 1 if (x,y) is (0,0) or (1,1), else 0 -> z = ~(x ^ y)
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Simplified Top-level module: instantiate one A and one B module
// Output z = A_out XOR B_out, which equals the original complex expression
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out, b_out;

    A a_inst (.x(x), .y(y), .z(a_out));
    B b_inst (.x(x), .y(y), .z(b_out));

    // Simplified output using XOR only
    assign z = a_out ^ b_out;
endmodule