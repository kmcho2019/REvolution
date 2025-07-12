module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    case ({c, d})
        2'b00: out = ~(a ^ b); // When c=0, d=0, out=1 if a=b
        2'b01: out = a | ~b;   // When c=0, d=1, out=1 if a=1 or b=0
        2'b10: out = b | ~a;   // When c=1, d=0, out=1 if b=1 or a=0
        2'b11: out = a | b;    // When c=1, d=1, out=1 if a=1 or b=1
    endcase

endmodule