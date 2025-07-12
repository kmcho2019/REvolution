module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Output follows x2 when x3=0, follows x1 when x3=1
    assign f = x3 ? x1 : x2;
endmodule