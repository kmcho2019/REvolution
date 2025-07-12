module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, can be ignored in logic
    output reg out
);

always @(*) begin
    // Concatenate inputs as {c, d, a, b} for easy pattern matching
    casez ({c, d, a, b})
        4'b00?1: out = 1'b1; // c=0,d=0,a=any,b=1 from first row 00 ab=10 and 11 (10=2,11=3)
        4'b00?0: out = 1'b0; // c=0,d=0,a=any,b=0 => 0 from row 00, ab=00

        4'b10??: out = 1'b1; // c=1,d=0 a=any b=any => all 1s in row 10 except d=don't care
        4'b11??: out = 1'b1; // c=1,d=1 a=any b=any => all 1s in row 11 except 01=0

        4'b0100: out = 1'b0; // c=0,d=1,a=0,b=0 from row 01 ab=00 is 0
        4'b0101: out = 1'b0; // c=0,d=1,a=0,b=1 from row 01 ab=01 is 0

        default: out = 1'b0; // any unspecified patterns => 0
    endcase
end

endmodule