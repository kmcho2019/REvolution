// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Refactored top-level module instantiating two As and two Bs explicitly
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // First pair of A and B driving OR gate
    A A1 (.x(x), .y(y), .z(a1_out));
    B B1 (.x(x), .y(y), .z(b1_out));
    assign or_out = a1_out | b1_out;

    // Second pair of A and B driving AND gate
    A A2 (.x(x), .y(y), .z(a2_out));
    B B2 (.x(x), .y(y), .z(b2_out));
    assign and_out = a2_out & b2_out;

    // XOR the outputs of OR and AND gates
    assign z = or_out ^ and_out;
endmodule