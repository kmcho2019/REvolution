// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x ^ y) (XNOR)
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Top module as described, simplified wiring
module top(input x, input y, output z);
    wire or_out = ( (x ^ y) & x ) | ~(x ^ y);
    wire and_out = ( (x ^ y) & x ) & ~(x ^ y);
    assign z = or_out ^ and_out;
endmodule