module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire odd_parity;

    assign odd_parity = a ^ b ^ c ^ d;
    assign q = ~odd_parity;
endmodule