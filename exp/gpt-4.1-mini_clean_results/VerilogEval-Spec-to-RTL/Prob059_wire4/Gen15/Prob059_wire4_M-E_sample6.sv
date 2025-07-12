module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    wire w_int;
    wire x_int;
    wire y_int;
    wire z_int;

    assign w_int = a;
    assign x_int = b;
    assign y_int = b;
    assign z_int = c;

    assign w = w_int;
    assign x = x_int;
    assign y = y_int;
    assign z = z_int;

endmodule