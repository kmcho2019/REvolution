module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement as 2:1 mux with x3 as select
    assign f = x3 ? x1 : x2;
endmodule