module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
    // Inferred from waveform: z = ~(x ^ y)
    assign z = ~(x ^ y);
endmodule

// Composite module that instantiates one A and one B, producing or_out and and_out signals
module AB_Pair(input wire x, input wire y, output wire or_out, output wire and_out);
    wire a_out, b_out;

    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
endmodule

module TopModule(input wire x, input wire y, output wire z);
    wire or1, and1;
    wire or2, and2;

    // Two AB_Pair instances correspond to the original two pairs of A and B modules
    AB_Pair pair1(.x(x), .y(y), .or_out(or1), .and_out(and1));
    AB_Pair pair2(.x(x), .y(y), .or_out(or2), .and_out(and2));

    // XOR of the OR and AND outputs of the two pairs
    assign z = (or1 ^ or2) ^ (and1 ^ and2);
endmodule