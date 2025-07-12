module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Direct assignment using ternary operator
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Procedural assignment using assign statement
assign out_always = (sel_b1 && sel_b2)? b : a;

endmodule