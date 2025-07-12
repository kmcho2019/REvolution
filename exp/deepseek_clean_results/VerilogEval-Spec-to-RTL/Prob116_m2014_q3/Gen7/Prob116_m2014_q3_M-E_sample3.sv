module TopModule(
    input [3:0] x,  // x[3],x[2],x[1],x[0] (x[0] is x[4] in K-map)
    output f
);
    wire row00 = ~(x[1] & ~x[2]);  // 00 row logic
    wire row01 = x[1] & x[2];      // 01 row logic
    wire row11 = ~x[1];            // 11 row logic
    wire row10 = ~(~x[1] & x[2]);  // 10 row logic

    assign f = (~x[3] & ~x[0]) ? row00 :
               (~x[3] &  x[0]) ? row01 :
               ( x[3] &  x[0]) ? row11 :
                                 row10;
endmodule