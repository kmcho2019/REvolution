module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

wire carry_out;

assign s = a + b;
assign {carry_out, s} = {1'b0, a} + {1'b0, b};

assign overflow = (a[7] == b[7]) && (a[7] != s[7]);

endmodule