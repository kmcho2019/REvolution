module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire p, g;

    assign g = a & b;        // generate
    assign p = a ^ b;        // propagate

    assign sum  = p ^ cin;
    assign cout = g | (p & cin);
endmodule