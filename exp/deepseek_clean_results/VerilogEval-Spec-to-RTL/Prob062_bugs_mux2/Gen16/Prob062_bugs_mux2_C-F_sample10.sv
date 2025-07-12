module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = sel ? b : a;  // Note: swapped a and b to match typical mux convention

endmodule