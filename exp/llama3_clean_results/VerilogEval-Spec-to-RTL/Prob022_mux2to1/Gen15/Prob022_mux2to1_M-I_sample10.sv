module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// The ternary operator is used for its conciseness and clarity in expressing the multiplexer's logic.
// This implementation directly corresponds to the desired multiplexer behavior and is likely to be optimized well by synthesizers.
assign out = (sel) ? b : a;
endmodule