module NOT1 (
    input  a,
    output y
);
    assign y = ~a;
endmodule

module AND2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

module OR2 (
    input  a,
    input  b,
    output y
);
    assign y = a | b;
endmodule

module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    wire not_x3;
    wire and1_out;
    wire and2_out;

    // not_x3 = ~x3
    NOT1 u_not1(.a(x3), .y(not_x3));
    // and1_out = ~x3 & x2
    AND2 u_and1(.a(not_x3), .b(x2), .y(and1_out));
    // and2_out = x3 & x1
    AND2 u_and2(.a(x3), .b(x1), .y(and2_out));
    // f = and1_out | and2_out
    OR2  u_or1(.a(and1_out), .b(and2_out), .y(f));
endmodule