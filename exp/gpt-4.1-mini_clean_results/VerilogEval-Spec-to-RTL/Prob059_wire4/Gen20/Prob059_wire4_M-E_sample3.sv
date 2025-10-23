module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Internal wires that mirror inputs
    wire a_int;
    wire b_int;
    wire c_int;

    // Capture inputs
    assign a_int = a;
    assign b_int = b;
    assign c_int = c;

    // Drive outputs from internal wires
    assign w = a_int;
    assign x = b_int;
    assign y = b_int;
    assign z = c_int;

endmodule