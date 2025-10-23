module AndAssign (
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

module AndAlways (
    input a,
    input b,
    output reg out
);
    always @(*) out = a & b;
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Instantiate both implementations
    AndAssign u_assign (.a(a), .b(b), .out(out_assign));
    AndAlways u_always (.a(a), .b(b), .out(out_alwaysblock));
endmodule