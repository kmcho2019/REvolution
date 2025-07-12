module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_bits = {a, b, c, d, e};

    assign out = {
        (in_bits[0] ~^ in_bits[0]), (in_bits[0] ~^ in_bits[1]), (in_bits[0] ~^ in_bits[2]), (in_bits[0] ~^ in_bits[3]), (in_bits[0] ~^ in_bits[4]),
        (in_bits[1] ~^ in_bits[0]), (in_bits[1] ~^ in_bits[1]), (in_bits[1] ~^ in_bits[2]), (in_bits[1] ~^ in_bits[3]), (in_bits[1] ~^ in_bits[4]),
        (in_bits[2] ~^ in_bits[0]), (in_bits[2] ~^ in_bits[1]), (in_bits[2] ~^ in_bits[2]), (in_bits[2] ~^ in_bits[3]), (in_bits[2] ~^ in_bits[4]),
        (in_bits[3] ~^ in_bits[0]), (in_bits[3] ~^ in_bits[1]), (in_bits[3] ~^ in_bits[2]), (in_bits[3] ~^ in_bits[3]), (in_bits[3] ~^ in_bits[4]),
        (in_bits[4] ~^ in_bits[0]), (in_bits[4] ~^ in_bits[1]), (in_bits[4] ~^ in_bits[2]), (in_bits[4] ~^ in_bits[3]), (in_bits[4] ~^ in_bits[4])
    };
endmodule