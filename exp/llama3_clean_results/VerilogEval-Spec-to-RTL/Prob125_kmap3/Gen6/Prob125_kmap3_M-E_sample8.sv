module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Internal signals
wire out_when_c0;
wire out_when_c1;

// Logic when c is 0
assign out_when_c0 = a || (!a && !b);

// Logic when c is 1
assign out_when_c1 = a || (!a && b);

// 2-to-1 multiplexer to select output based on c
assign out = c ? out_when_c1 : out_when_c0;

endmodule