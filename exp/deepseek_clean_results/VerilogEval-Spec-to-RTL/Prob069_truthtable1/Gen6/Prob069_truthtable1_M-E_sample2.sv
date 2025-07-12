module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement as a 2:1 multiplexer
    // x3 is selector: 0 selects x2, 1 selects x1
    assign f = x3 ? x1 : x2;
endmodule