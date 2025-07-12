module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    case ({c, d})
        2'b00: out = a ^ b;
        2'b01: out = ~b;
        2'b10: out = ~a;
        2'b11: out = b | ~a;
    endcase

endmodule