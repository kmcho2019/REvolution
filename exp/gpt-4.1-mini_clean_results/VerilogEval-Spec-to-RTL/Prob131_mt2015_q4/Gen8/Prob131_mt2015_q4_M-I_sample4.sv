// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = XNOR(x,y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with two instances of A and B, using continuous assignments for combinational logic
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate first A and B modules
    A A1 (.x(x), .y(y), .z(a1_out));
    B B1 (.x(x), .y(y), .z(b1_out));

    // Instantiate second A and B modules
    A A2 (.x(x), .y(y), .z(a2_out));
    B B2 (.x(x), .y(y), .z(b2_out));

    // Continuous assignments for combinational logic
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;
endmodule