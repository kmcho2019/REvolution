module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // MUX implementation where:
    // When x3=0, f = x2
    // When x3=1, f = x1
    assign f = x3 ? x1 : x2;
endmodule