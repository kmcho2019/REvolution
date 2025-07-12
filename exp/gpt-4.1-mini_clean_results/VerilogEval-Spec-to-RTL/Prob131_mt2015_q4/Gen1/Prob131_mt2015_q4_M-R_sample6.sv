// Module A: z = (x ^ y) & x, implemented using always_comb
module A(input wire x, input wire y, output reg z);
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule

// Module B: z = XNOR(x,y), implemented with always_comb and intermediate wire
module B(input wire x, input wire y, output reg z);
    wire x_xor_y;
    assign x_xor_y = x ^ y;

    always @(*) begin
        z = ~x_xor_y;
    end
endmodule

// Top-level module using gate-level primitives for internal connections
module top(input wire x, input wire y, output wire z);
    wire a1, a2, b1, b2;
    wire or_out, and_out;

    // Instantiate two A modules
    A A1(.x(x), .y(y), .z(a1));
    A A2(.x(x), .y(y), .z(a2));

    // Instantiate two B modules
    B B1(.x(x), .y(y), .z(b1));
    B B2(.x(x), .y(y), .z(b2));

    // Use gate-level primitives to implement OR and AND gates
    or or_gate(or_out, a1, b1);
    and and_gate(and_out, a2, b2);

    // XOR gate for final output
    xor xor_gate(z, or_out, and_out);
endmodule