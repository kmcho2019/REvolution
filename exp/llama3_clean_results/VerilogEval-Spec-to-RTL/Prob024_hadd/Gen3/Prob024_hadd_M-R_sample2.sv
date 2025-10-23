module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);
    
    // Directly calculate sum and carry using basic logic operations
    assign {cout, sum} = a + b;

endmodule