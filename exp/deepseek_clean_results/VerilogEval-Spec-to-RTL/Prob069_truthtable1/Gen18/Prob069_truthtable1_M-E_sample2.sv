module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement as a 2:1 multiplexer
    assign f = x3 ? x1 : x2;
endmodule