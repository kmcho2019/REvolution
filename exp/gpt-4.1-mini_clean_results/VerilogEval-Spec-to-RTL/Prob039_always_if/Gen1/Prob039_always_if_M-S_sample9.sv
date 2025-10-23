module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Continuous assignment implementing the mux
assign out_assign = (sel_b1 & sel_b2) ? b : a;

// Drive out_always directly from out_assign
assign out_always = out_assign;

endmodule