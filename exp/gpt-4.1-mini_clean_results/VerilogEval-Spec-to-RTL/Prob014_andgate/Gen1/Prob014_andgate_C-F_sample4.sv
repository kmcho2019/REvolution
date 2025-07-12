// TopModule: Implements a 2-input AND gate with inputs a and b and output out.
module TopModule(
    input  wire a,
    input  wire b,
    output wire out
);

// Continuous assignment for AND logic
assign out = a & b;

endmodule