module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

    wire sum_internal;
    wire cout_internal;

    // Half adder implementation using primitive gates
    xor u_xor(sum_internal, a, b);
    and u_and(cout_internal, a, b);

    assign sum = sum_internal;
    assign cout = cout_internal;

endmodule