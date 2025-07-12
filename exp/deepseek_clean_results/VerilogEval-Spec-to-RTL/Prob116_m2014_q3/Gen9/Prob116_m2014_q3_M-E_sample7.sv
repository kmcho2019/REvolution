module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // Decode x[3:4] (MSBs) into one-hot
    wire row00 = ~x[3] & ~x[2];
    wire row01 = ~x[3] &  x[2];
    wire row11 =  x[3] &  x[2];
    wire row10 =  x[3] & ~x[2];

    // Implement column logic for each row
    wire col_logic00 = 0;  // From K-map: row00 always 0 or d (we choose 0)
    wire col_logic01 = (~x[1] & ~x[0]) ? 0 :  // 00 case
                      (x[1] & x[0]) ? 1 :     // 11 case
                      0;                      // default for 01,10 cases
    wire col_logic11 = (x[1] | ~x[0]) ? 1 : 0;  // 1 for all but x[1]x[0]=00
    wire col_logic10 = (~x[1] & x[0]) ? 0 : 1;  // 0 only for x[1]x[0]=01

    // Final output mux
    assign f = (row00 & col_logic00) |
               (row01 & col_logic01) |
               (row11 & col_logic11) |
               (row10 & col_logic10);
endmodule