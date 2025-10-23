module Buffer (
    input  wire in,
    output wire out1,
    output wire out2
);
    assign out1 = in;
    assign out2 = in;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Direct assignments for unique outputs to minimize area and power
    assign w = a;
    assign z = c;

    // Shared buffer driving both x and y from b to preserve modular clarity with minimal overhead
    Buffer buf_b (
        .in(b),
        .out1(x),
        .out2(y)
    );

endmodule