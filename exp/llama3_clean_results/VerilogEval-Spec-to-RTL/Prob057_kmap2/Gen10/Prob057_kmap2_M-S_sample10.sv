module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    case ({a, b})
        2'b00: out = (c == 1'b0) && (d != 1'b1);
        2'b01: out = 1'b1;
        2'b11: out = 1'b1;
        2'b10: out = (c == 1'b0) || (d == 1'b0);
    endcase

endmodule