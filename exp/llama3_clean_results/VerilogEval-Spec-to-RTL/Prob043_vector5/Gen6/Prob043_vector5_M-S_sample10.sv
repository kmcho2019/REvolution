module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

genvar i, j;
generate
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            assign out[i*5 + j] = (i == 0)? (~a ^ {a, b, c, d, e}[j]) : 
                                    (i == 1)? (~b ^ {a, b, c, d, e}[j]) : 
                                    (i == 2)? (~c ^ {a, b, c, d, e}[j]) : 
                                    (i == 3)? (~d ^ {a, b, c, d, e}[j]) : 
                                    (~e ^ {a, b, c, d, e}[j]);
        end
    end
endgenerate

endmodule