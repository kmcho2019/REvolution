// 2-input OR gate module definition
module Or2 (
    input  x,
    input  y,
    output q
);
    assign q = x | y;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    wire ab_or;

    // Instantiate one 2-input OR gate for (a | b)
    Or2 or2_inst (
        .x(a),
        .y(b),
        .q(ab_or)
    );

    // Combine the output of Or2 with c using direct OR operator
    assign out = ab_or | c;

endmodule