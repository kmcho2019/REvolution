module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    wire and1_out;  // Output of first AND gate
    wire and2_out;  // Output of second AND gate

    // First AND gate
    and and1(
       .a(a),
       .b(b),
       .out(and1_out)
    );

    // Second AND gate
    and and2(
       .a(c),
       .b(d),
       .out(and2_out)
    );

    // OR gate
    or or1(
       .a(and1_out),
       .b(and2_out),
       .out(out)
    );

    // NOT gate
    not not1(
       .a(out),
       .out(out_n)
    );

endmodule