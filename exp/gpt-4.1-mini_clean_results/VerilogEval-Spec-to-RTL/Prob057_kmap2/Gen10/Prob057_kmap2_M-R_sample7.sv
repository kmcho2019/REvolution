module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*) begin
    case ({c, d, a, b})
        4'b0000: out = 1; // c=0,d=0,a=0,b=0 => cd=00 ab=00 (1)
        4'b0001: out = 1; // 00 01 (1)
        4'b0010: out = 1; // 00 10 (1)
        4'b0100: out = 1; // 01 00 (1)
        4'b0110: out = 1; // 01 10 (1)
        4'b1011: out = 1; // 11 01 (1)
        4'b1100: out = 1; // 11 11 (1)
        4'b1101: out = 1; // 11 10 (1)
        4'b1000: out = 1; // 10 00 (1)
        4'b1001: out = 1; // 10 01 (1)
        default: out = 0;
    endcase
end

endmodule