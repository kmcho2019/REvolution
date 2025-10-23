module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Internal wires for the NOR gate outputs
wire nor1_out, nor2_out;

// NOR gates cross-coupled with inputs
assign nor1_out = ~(x | nor2_out);
assign nor2_out = ~(y | nor1_out);

// Output z is the output of one NOR gate representing XNOR behavior
assign z = nor2_out;

endmodule