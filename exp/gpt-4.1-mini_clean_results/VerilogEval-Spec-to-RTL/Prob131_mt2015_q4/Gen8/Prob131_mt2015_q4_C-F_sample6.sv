// Module A implements z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B implements z = ~(x ^ y) (XNOR)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module:
// - Instantiates one A and one B with inputs x, y
// - Uses outputs of A and B for two logic operations: OR and AND
// - XORs the results of these operations for final output z
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;   // Outputs from modules A and B
    wire or_out, and_out; // Outputs of OR and AND gates

    // Instantiate A and B modules once each
    A a_inst (.x(x), .y(y), .z(a_out));
    B b_inst (.x(x), .y(y), .z(b_out));

    // OR gate combining outputs of A and B
    assign or_out = a_out | b_out;

    // AND gate combining outputs of A and B
    assign and_out = a_out & b_out;

    // Final XOR of OR and AND outputs to produce z
    assign z = or_out ^ and_out;
endmodule