module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// The most straightforward implementation directly uses XOR and XNOR operations.
// Since both are basic operations directly supported by Verilog, this approach is already quite efficient.
assign out = ~(in1 ^ in2) ^ in3;

endmodule