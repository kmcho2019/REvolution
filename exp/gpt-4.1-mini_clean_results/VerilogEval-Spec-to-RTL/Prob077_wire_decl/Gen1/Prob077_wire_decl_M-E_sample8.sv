module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire [1:0] and_outputs;

and and_gate0(and_outputs[0], a, b);
and and_gate1(and_outputs[1], c, d);

or (out, and_outputs[0], and_outputs[1]);

not (out_n, out);

endmodule