// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output matches waveform, i.e., XNOR of x and y
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module as per specification:
// - two instances of A and B each with inputs x,y
// - first A and B outputs OR'ed
// - second A and B outputs AND'ed
// - final XOR of OR and AND drives z
module TopModule(input wire x, input wire y, output wire z);
    // Wires for outputs of A and B instances
    wire a1_out, a2_out;
    wire b1_out, b2_out;

    // Instantiate two A modules
    A a1(.x(x), .y(y), .z(a1_out));
    A a2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B b1(.x(x), .y(y), .z(b1_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // OR gate combining first A and B outputs
    wire or_out = a1_out | b1_out;

    // AND gate combining second A and B outputs
    wire and_out = a2_out & b2_out;

    // XOR gate combining OR and AND outputs
    assign z = or_out ^ and_out;
endmodule