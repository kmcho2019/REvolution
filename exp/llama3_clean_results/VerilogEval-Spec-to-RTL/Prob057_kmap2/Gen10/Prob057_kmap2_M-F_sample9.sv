module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (!a && !b && !c && !d) ||  // 00, 00
             (!a && !b && !c &&  d) ||  // 00, 01
             (!a && !b &&  c &&  d) ||  // 00, 11
             (!a &&  b && !c && !d) ||  // 01, 00
             (!a &&  b &&  c && !d) ||  // 01, 10
             ( a &&  b && !c &&  d) ||  // 11, 01
             ( a &&  b &&  c &&  d) ||  // 11, 11
             (!a &&  b &&  c &&  d);    // 01, 11

endmodule