module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Intermediate internal wires
    wire a_int;
    wire b_int;
    wire c_int;

    // Drive internal wires from inputs
    assign a_int = a;
    assign b_int = b;
    assign c_int = c;

    // Outputs driven from intermediate wires
    assign w = a_int;
    assign x = b_int;
    assign y = b_int;
    assign z = c_int;

endmodule