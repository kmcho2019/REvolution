// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Optimized top-level module sharing outputs of single A and B instances
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single instances of A and B modules
    A A1 (.x(x), .y(y), .z(a_out));
    B B1 (.x(x), .y(y), .z(b_out));

    // Use the same outputs for both OR and AND gates as per original logic
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;

    // XOR the outputs of OR and AND gates
    assign z = or_out ^ and_out;
endmodule