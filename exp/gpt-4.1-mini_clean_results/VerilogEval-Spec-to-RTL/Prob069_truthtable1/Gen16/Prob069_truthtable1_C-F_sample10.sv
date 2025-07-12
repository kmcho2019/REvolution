module NOT1 (
    input  wire a,
    output wire y
);
    assign y = ~a;
endmodule

module AND2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a & b;
endmodule

module OR2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a | b;
endmodule

module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);
    wire nx3;
    wire term1, term2;

    // nx3 = ~x3
    NOT1 u_not1 (.a(x3), .y(nx3));

    // term1 = ~x3 & x2
    AND2 u_and1 (.a(nx3), .b(x2), .y(term1));

    // term2 = x3 & x1
    AND2 u_and2 (.a(x3), .b(x1), .y(term2));

    // f = term1 | term2
    OR2 u_or1 (.a(term1), .b(term2), .y(f));
endmodule