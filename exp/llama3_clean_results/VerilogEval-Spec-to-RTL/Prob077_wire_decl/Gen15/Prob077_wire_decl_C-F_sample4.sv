// Define AND gate module
module AND_Gate(
    input  a,
    input  b,
    output out
);
    assign out = a & b;
endmodule

// Define OR gate module
module OR_Gate(
    input  a,
    input  b,
    output out
);
    assign out = a | b;
endmodule

// Define TopModule
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and_out1, and_out2;

    // Instantiate AND gates
    AND_Gate and_gate1(
      .a(a),
      .b(b),
      .out(and_out1)
    );

    AND_Gate and_gate2(
      .a(c),
      .b(d),
      .out(and_out2)
    );

    // Instantiate OR gate
    OR_Gate or_gate(
      .a(and_out1),
      .b(and_out2),
      .out(out)
    );

    // Assign out_n as the inverse of out
    assign out_n = ~out;
endmodule