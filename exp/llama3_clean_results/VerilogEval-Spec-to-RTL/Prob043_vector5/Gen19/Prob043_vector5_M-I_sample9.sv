module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    genvar i;
    generate
        for (i = 0; i < 25; i++) begin
            assign out[i] = ~(a ^ a);
            if (i == 1) assign out[i] = ~(a ^ b);
            else if (i == 2) assign out[i] = ~(a ^ c);
            else if (i == 3) assign out[i] = ~(a ^ d);
            else if (i == 4) assign out[i] = ~(a ^ e);
            else if (i == 5) assign out[i] = ~(b ^ a);
            else if (i == 6) assign out[i] = ~(b ^ b);
            else if (i == 7) assign out[i] = ~(b ^ c);
            else if (i == 8) assign out[i] = ~(b ^ d);
            else if (i == 9) assign out[i] = ~(b ^ e);
            else if (i == 10) assign out[i] = ~(c ^ a);
            else if (i == 11) assign out[i] = ~(c ^ b);
            else if (i == 12) assign out[i] = ~(c ^ c);
            else if (i == 13) assign out[i] = ~(c ^ d);
            else if (i == 14) assign out[i] = ~(c ^ e);
            else if (i == 15) assign out[i] = ~(d ^ a);
            else if (i == 16) assign out[i] = ~(d ^ b);
            else if (i == 17) assign out[i] = ~(d ^ c);
            else if (i == 18) assign out[i] = ~(d ^ d);
            else if (i == 19) assign out[i] = ~(d ^ e);
            else if (i == 20) assign out[i] = ~(e ^ a);
            else if (i == 21) assign out[i] = ~(e ^ b);
            else if (i == 22) assign out[i] = ~(e ^ c);
            else if (i == 23) assign out[i] = ~(e ^ d);
            else if (i == 24) assign out[i] = ~(e ^ e);
        end
    endgenerate

endmodule