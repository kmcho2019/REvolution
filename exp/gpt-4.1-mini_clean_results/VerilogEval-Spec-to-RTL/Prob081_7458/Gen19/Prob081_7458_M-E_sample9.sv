module TopModule (
    input  wire p1a,
    input  wire p1b,
    input  wire p1c,
    input  wire p1d,
    input  wire p1e,
    input  wire p1f,
    input  wire p2a,
    input  wire p2b,
    input  wire p2c,
    input  wire p2d,
    output wire p1y,
    output wire p2y
);

    wire and1, and2, and3, and4;

    // Four AND gates (three-input for p1, two-input for p2)
    assign and1 = p1a & p1b & p1c;
    assign and2 = p1d & p1e & p1f;
    assign and3 = p2a & p2b;
    assign and4 = p2c & p2d;

    // Two OR gates combining the AND outputs
    assign p1y = and1 | and2;
    assign p2y = and3 | and4;

endmodule