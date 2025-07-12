module NotGate (
    input  a,
    output y
);
    assign y = ~a;
endmodule

module AndGate (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire not_in2;

    // Instantiate a NOT gate to create the bubble on in2
    NotGate u_not (
        .a(in2),
        .y(not_in2)
    );

    // Instantiate an AND gate with inputs in1 and inverted in2
    AndGate u_and (
        .a(in1),
        .b(not_in2),
        .y(out)
    );

endmodule