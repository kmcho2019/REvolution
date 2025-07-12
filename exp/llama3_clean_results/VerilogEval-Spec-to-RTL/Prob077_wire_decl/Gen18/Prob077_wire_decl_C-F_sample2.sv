module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires to connect AND gates to OR gate
    wire and_out1, and_out2;

    // AND gates
    assign and_out1 = a & b;  // AND gate for inputs a and b
    assign and_out2 = c & d;  // AND gate for inputs c and d

    // OR gate
    assign out = and_out1 | and_out2;  // OR gate for AND gate outputs

    // NOT gate
    assign out_n = ~out;  // Inverted output

endmodule