module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output is high when inputs are equal: z = XNOR of x and y
assign z = x ~^ y;

endmodule