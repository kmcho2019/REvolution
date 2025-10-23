module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

// Carry-out is directly the AND of inputs
assign cout = a & b;

// Sum implemented as a 2-to-1 mux selecting between b and ~b based on a
assign sum = a ? ~b : b;

endmodule