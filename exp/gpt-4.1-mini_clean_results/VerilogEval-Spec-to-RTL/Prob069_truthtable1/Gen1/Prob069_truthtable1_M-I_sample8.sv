module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    // Implement the function as a 2:1 mux: if x3==1 select x1 else select x2
    assign f = x3 ? x1 : x2;
endmodule