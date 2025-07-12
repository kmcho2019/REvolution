module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

    wire sum_wire;
    wire cout_wire;

    // Gate-level primitives for clarity and minimal logic
    xor (sum_wire, a, b);
    and (cout_wire, a, b);

    // Continuous assignments expose outputs directly as combinational logic
    assign sum = sum_wire;
    assign cout = cout_wire;

endmodule