// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module using single instances of A and B reused for both pairs
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;
    wire or_out, and_out;

    A A_inst(.x(x), .y(y), .z(a_out));
    B B_inst(.x(x), .y(y), .z(b_out));

    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
    assign z = or_out ^ and_out;
endmodule