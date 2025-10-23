module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

wire nx, ny;
wire and0, and1;

assign nx = ~x;
assign ny = ~y;

assign and0 = nx & ny; // both inputs 0
assign and1 = x & y;   // both inputs 1

assign z = and0 | and1; // output high if inputs equal

endmodule