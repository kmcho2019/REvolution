// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x ^ y)
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Simplified top-level module with one A and one B reused for both OR and AND gates
module TopModule(input x, input y, output z);
    wire a_out, b_out;
    wire or_out, and_out;

    A A_inst(.x(x), .y(y), .z(a_out));
    B B_inst(.x(x), .y(y), .z(b_out));

    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
    assign z = or_out ^ and_out;
endmodule