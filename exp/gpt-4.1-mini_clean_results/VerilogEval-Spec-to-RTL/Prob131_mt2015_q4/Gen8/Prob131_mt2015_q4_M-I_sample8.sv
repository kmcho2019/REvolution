// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output matches waveform, i.e., XNOR of x and y
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Optimized Top-level module:
// - one instance of A and one instance of B, inputs x,y
// - OR and AND gates both use the same A and B outputs
// - final XOR of OR and AND produces output z
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;

    // Single instance each of A and B
    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;

    assign z = or_out ^ and_out;
endmodule