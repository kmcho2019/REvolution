module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // The ^ operator represents XOR, and ~ inverts the result, thus implementing an XNOR gate.

endmodule