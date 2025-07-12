module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);
    // Explicit continuous assignment for 2:1 mux
    // Maintains optimal PPA while being more explicit
    assign out = (sel == 1'b1) ? b : a;
endmodule