// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x ^ y) matching given waveform
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Simplified top-level module reusing single A and B outputs
module TopModule(input x, input y, output z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single instances of A and B modules
    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    // Use the same outputs for both OR and AND gates
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;

    // Final XOR for output z
    assign z = or_out ^ and_out;
endmodule