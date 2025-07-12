module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Combine AND and OR operations in one continuous assignment to minimize area and power
    assign out = (a & b) | (c & d);
    assign out_n = ~out;
endmodule