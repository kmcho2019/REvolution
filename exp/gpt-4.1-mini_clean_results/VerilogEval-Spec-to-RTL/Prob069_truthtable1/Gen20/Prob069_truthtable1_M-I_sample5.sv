module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    // Direct combinational implementation: f = x3 ? x1 : x2
    assign f = x3 ? x1 : x2;
endmodule