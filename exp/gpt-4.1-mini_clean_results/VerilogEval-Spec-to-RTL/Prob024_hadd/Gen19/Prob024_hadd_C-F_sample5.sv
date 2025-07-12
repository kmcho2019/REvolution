module HalfAdder (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);
    // Pure combinational logic for half adder
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);
    // Instantiate half adder submodule once for modularity and clarity
    HalfAdder hadd (
        .a(a),
        .b(b),
        .sum(sum),
        .cout(cout)
    );
endmodule