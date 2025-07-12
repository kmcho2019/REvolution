module TopModule(
    input [3:0] x,  // x[3:4] are mux select, x[1:2] are data inputs
    output f
);
    // Row implementations (optimized using don't-cares)
    wire row00 = 1'b0;  // All don't-cares set to 0 for optimization
    wire row01 = (~x[1] & ~x[2]) | (x[1] & x[2]);
    wire row11 = 1'b1;  // All don't-cares set to 1 for optimization
    wire row10 = ~(x[1] & ~x[2]);

    // 4:1 mux implementation
    assign f = (~x[3] & ~x[4]) ? row00 :
               (~x[3] &  x[4]) ? row01 :
               ( x[3] &  x[4]) ? row11 :
                                 row10;
endmodule