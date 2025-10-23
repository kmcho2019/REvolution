module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Intermediate signal eq: 1 if x == y, 0 otherwise
wire eq;
assign eq = (x & y) | (~x & ~y);

// 2-to-1 mux driven by eq:
// if eq==1 => z=1, else z=0
assign z = eq ? 1'b1 : 1'b0;

endmodule