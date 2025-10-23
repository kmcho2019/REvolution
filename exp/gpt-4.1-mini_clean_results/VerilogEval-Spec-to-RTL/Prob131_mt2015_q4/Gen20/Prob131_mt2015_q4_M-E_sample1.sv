// Module A: implement z = (x ^ y) & x using gates
module A(input wire x, input wire y, output wire z);
    wire xor_out;
    xor u_xor(xor_out, x, y);
    and u_and(z, xor_out, x);
endmodule

// Module B: implement z = ~(x ^ y) using gates
module B(input wire x, input wire y, output wire z);
    wire xor_out;
    xor u_xor(xor_out, x, y);
    not u_not(z, xor_out);
endmodule

// Top-level module instantiating two A and two B modules with gate-level interconnect
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // First pair of modules
    A A1(.x(x), .y(y), .z(a1_out));
    B B1(.x(x), .y(y), .z(b1_out));

    // Second pair of modules
    A A2(.x(x), .y(y), .z(a2_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // Gates combining outputs of first pair: OR gate
    or u_or(or_out, a1_out, b1_out);

    // Gates combining outputs of second pair: AND gate
    and u_and(and_out, a2_out, b2_out);

    // XOR gate combining the outputs of OR and AND gates for final output
    xor u_xor(z, or_out, and_out);
endmodule