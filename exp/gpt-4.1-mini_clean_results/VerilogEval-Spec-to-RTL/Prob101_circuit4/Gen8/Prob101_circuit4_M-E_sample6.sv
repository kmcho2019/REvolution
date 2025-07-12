module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire b_active;
    wire c_active;

    assign b_active = b;
    assign c_active = c;

    assign q = b_active | c_active;

endmodule