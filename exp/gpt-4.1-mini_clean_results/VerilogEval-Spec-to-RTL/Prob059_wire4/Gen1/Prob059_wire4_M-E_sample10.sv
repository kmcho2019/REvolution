module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    wire wa, xb, yb, zc;

    assign wa = a;
    assign xb = b;
    assign yb = b;
    assign zc = c;

    assign w = wa;
    assign x = xb;
    assign y = yb;
    assign z = zc;

endmodule