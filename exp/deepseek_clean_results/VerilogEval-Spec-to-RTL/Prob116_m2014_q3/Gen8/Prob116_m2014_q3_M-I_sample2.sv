module TopModule(
    input [3:0] x,  // x[3],x[2],x[1],x[0] (x[0] is x[4])
    output f
);
    // Row logic implementations
    wire row00 = ~(~x[1] & x[2]);  // 0 only at 01, others 1
    wire row01 = x[1] & x[2];      // 1 only at 11
    wire row11 = ~x[2] | x[1];     // 1 at 00 and 01 (optimized using don't-cares)
    wire row10 = ~(~x[1] & ~x[2]); // 0 only at 10, others 1

    // 4:1 mux implementation
    assign f = (~x[3] & ~x[0]) ? row00 :
               (~x[3] &  x[0]) ? row01 :
               ( x[3] &  x[0]) ? row11 :
                                 row10;
endmodule