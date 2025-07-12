module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Explicitly define wiring for clarity and easy maintenance
    localparam string WIRE_A_TO_W = "a -> w";
    localparam string WIRE_B_TO_X = "b -> x";
    localparam string WIRE_B_TO_Y = "b -> y";
    localparam string WIRE_C_TO_Z = "c -> z";

    // Direct continuous assignments for optimal power and area
    assign w = a; // WIRE_A_TO_W
    assign x = b; // WIRE_B_TO_X
    assign y = b; // WIRE_B_TO_Y
    assign z = c; // WIRE_C_TO_Z

endmodule