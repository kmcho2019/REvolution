module NotGate(
    input in,
    output out
);
    assign out = ~in;
endmodule

module AndGate2(
    input x,
    input y,
    output z
);
    assign z = x & y;
endmodule

module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire nb, nc, and_out;

    NotGate not_b(.in(b), .out(nb));
    NotGate not_c(.in(c), .out(nc));
    AndGate2 and_gate(.x(nb), .y(nc), .z(and_out));
    NotGate not_out(.in(and_out), .out(q));
endmodule