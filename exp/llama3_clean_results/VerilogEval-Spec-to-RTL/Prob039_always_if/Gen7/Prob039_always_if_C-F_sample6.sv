module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Using a single assign statement for both outputs to minimize area
assign out_assign = (sel_b1 && sel_b2) ? b : a;
assign out_always = (sel_b1 && sel_b2) ? b : a;

endmodule