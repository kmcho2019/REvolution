module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care input
    output reg out
);

always @(*) begin
    // Based on the K-map, enumerate all minterms outputting '1'.
    // 'd' input is ignored; only combinations explicitly '1' are checked.
    // The inputs are a,b,c in order to index the K-map cells as specified.
    // The K-map row and column ordering corresponds to cd and ab respectively.

    // Truth table minterms where output is '1' (d can be 0 or 1, don't care):
    // From K-map:
    // cd\ab | 01 | 00 | 10 | 11
    // 00    | d  | 0  | 1  | 1
    // 01    | 0  | 0  | d  | d
    // 11    | 0  | 1  | 1  | 1
    // 10    | 0  | 1  | 1  | 1
    //
    // Let's decode minterms where output=1:
    // c=0,d=0; a,b=1,0 (i.e. ab=10) => a=1,b=0,c=0,d=0
    // c=0,d=0; a,b=1,1 (ab=11) => a=1,b=1,c=0,d=0
    // c=1,d=1; a,b=0,0 => a=0,b=0,c=1,d=1
    // c=1,d=1; a,b=0,1 => a=0,b=1,c=1,d=1
    // c=1,d=1; a,b=1,0 => a=1,b=0,c=1,d=1
    // c=1,d=1; a,b=1,1 => a=1,b=1,c=1,d=1
    // c=1,d=0; a,b=0,0 => a=0,b=0,c=1,d=0
    // c=1,d=0; a,b=0,1 => a=0,b=1,c=1,d=0
    // c=1,d=0; a,b=1,0 => a=1,b=0,c=1,d=0
    // c=1,d=0; a,b=1,1 => a=1,b=1,c=1,d=0

    // But notice many minterms have don't care d, so d is ignored in logic.
    // Explicitly check minterms with output=1:
    if      (c==0 && b==0 && a==1) out = 1; // c=0,b=0,a=1, matches 00/10 cell
    else if (c==0 && b==1 && a==1) out = 1; // 00/11 cell
    else if (c==1 && b==0)          out = 1; // 11/10,10/10 and 11/00,10/00 cells where b=0
    else if (c==1 && b==1)          out = 1; // 11/11,10/11 and 11/01,10/01
    else                           out = 0;
end

endmodule