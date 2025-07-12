module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);
    // 4:1 mux implementation
    assign f = (~x3 & ~x2) ? 1'b0 :
               (~x3 &  x2) ? 1'b1 :
               ( x3 & ~x2) ? x1   :
                             x1;
endmodule