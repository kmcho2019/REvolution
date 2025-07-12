module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
    // Derived from waveform: B implements XNOR(x,y)
    assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // Instantiate first pair of modules A and B
    A a1(.x(x), .y(y), .z(a1_out));
    B b1(.x(x), .y(y), .z(b1_out));

    // Instantiate second pair of modules A and B
    A a2(.x(x), .y(y), .z(a2_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // OR gate: output of first A and first B modules
    assign or_out = a1_out | b1_out;

    // AND gate: output of second A and second B modules
    assign and_out = a2_out & b2_out;

    // XOR gate: XOR of the OR and AND gate outputs for final z
    assign z = or_out ^ and_out;
endmodule