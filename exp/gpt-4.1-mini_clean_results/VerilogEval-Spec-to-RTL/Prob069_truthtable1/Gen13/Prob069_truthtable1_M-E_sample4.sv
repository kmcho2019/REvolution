module OR2 (
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

module AND2 (
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    wire or_out;

    OR2 or_gate (.a(x3), .b(x2), .y(or_out));
    AND2 and_gate (.a(or_out), .b(x1), .y(f));
endmodule