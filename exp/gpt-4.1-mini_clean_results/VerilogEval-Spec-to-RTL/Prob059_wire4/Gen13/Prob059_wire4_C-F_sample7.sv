module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Directly connect inputs to outputs with clear assignments
    assign w = a;  // a -> w
    assign x = b;  // b -> x
    assign y = b;  // b -> y
    assign z = c;  // c -> z

endmodule