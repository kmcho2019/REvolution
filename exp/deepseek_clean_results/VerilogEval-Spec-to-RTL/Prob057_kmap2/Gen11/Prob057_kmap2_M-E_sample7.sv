module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Mux inputs for each cd case
wire case00 = (~a & ~b) | (~a & b) | (a & ~b);  // cd=00: 1,1,0,1
wire case01 = (~a & ~b) | (a & ~b);             // cd=01: 1,0,0,1
wire case11 = (~a & b) | (a & b) | (a & ~b);    // cd=11: 0,1,1,1
wire case10 = (~a & ~b) | (~a & b);             // cd=10: 1,1,0,0

// 4:1 Mux with cd as select
assign out = (~c & ~d) ? case00 :
             (~c &  d) ? case01 :
             ( c &  d) ? case11 :
             ( c & ~d) ? case10 : 1'b0;

endmodule