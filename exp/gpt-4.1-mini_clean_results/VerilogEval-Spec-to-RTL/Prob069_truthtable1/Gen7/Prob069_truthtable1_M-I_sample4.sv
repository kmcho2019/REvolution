module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Continuous assignment implements mux: if x3=1 select x1 else x2
    assign f = x3 ? x1 : x2;

endmodule