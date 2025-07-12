module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // 4-to-1 MUX with x[3]x[4] as select
    assign f = (~x[3] & ~x[4]) ? 1'b0 :  // 00 case
               (~x[3] &  x[4]) ? x[1] :  // 01 case
               ( x[3] &  x[4]) ? 1'b1 :  // 11 case
               ~x[2];                     // 10 case
endmodule