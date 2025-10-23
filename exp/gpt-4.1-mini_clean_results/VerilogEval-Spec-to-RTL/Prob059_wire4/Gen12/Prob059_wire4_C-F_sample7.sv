module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Internal named wires for clarity and easy future modifications
    wire w_internal;
    wire x_internal;
    wire y_internal;
    wire z_internal;

    // Directly assign inputs to internal wires
    assign w_internal = a;
    assign x_internal = b;
    assign y_internal = b;
    assign z_internal = c;

    // Drive outputs from internal wires
    assign w = w_internal;
    assign x = x_internal;
    assign y = y_internal;
    assign z = z_internal;

endmodule