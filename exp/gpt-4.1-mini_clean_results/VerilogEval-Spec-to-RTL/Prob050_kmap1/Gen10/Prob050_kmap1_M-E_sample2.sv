// 2-input OR gate module
module Or2 (
    input  x,
    input  y,
    output z
);
    assign z = x | y;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    wire or_bc;

    // OR b and c first
    Or2 or2_bc (.x(b), .y(c), .z(or_bc));

    // OR result with a
    Or2 or2_out (.x(a), .y(or_bc), .z(out));

endmodule