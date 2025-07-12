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

    // Direct assignments for unique one-to-one output connections
    assign w = a;
    assign z = c;

    // Single shared buffer instance driving both x and y from b
    Buffer buf_b (.in(b), .out1(x), .out2(y));

endmodule