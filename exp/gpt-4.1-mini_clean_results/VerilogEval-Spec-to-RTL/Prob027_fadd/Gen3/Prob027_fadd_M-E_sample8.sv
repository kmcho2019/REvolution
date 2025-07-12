module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire p, g;
    assign p = a ^ b;        // propagate
    assign g = a & b;        // generate
    assign sum = p ^ cin;    // sum = propagate xor cin
    assign cout = g | (p & cin); // carry-out
endmodule