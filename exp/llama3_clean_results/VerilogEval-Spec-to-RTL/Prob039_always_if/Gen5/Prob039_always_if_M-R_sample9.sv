module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Direct assignment for out_assign
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Direct assignment for out_always, applying the same logic as out_assign
assign out_always = (sel_b1 && sel_b2)? b : a;

endmodule