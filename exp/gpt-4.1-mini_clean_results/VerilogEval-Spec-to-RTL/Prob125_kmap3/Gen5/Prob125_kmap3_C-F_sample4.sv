module TopModule(
    input a,
    input b,
    input c,
    input d,      // d is don't-care, omitted from logic
    output out
);

wire not_b = ~b;
assign out = a | (c & not_b);

endmodule