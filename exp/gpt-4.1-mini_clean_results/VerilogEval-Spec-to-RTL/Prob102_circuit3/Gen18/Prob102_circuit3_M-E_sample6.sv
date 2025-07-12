module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire s;      // select signal: OR of a and b
    wire cd_or;  // OR of c and d

    assign s = a | b;
    assign cd_or = c | d;

    // Multiplexer: if s == 1 then q = cd_or else q = 0
    assign q = s ? cd_or : 1'b0;

endmodule