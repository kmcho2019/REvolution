module TopModule (
    input in1,
    input in2,
    output out
);

    wire in2_not;

    // Instantiate NOT gate for the bubble on in2
    not u_not (.Y(in2_not), .A(in2));

    // Instantiate AND gate with in1 and inverted in2
    and u_and (.Y(out), .A(in1), .B(in2_not));

endmodule