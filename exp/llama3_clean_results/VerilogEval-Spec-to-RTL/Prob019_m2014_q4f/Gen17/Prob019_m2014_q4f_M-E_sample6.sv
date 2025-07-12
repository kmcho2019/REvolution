module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using a NOR gate followed by a NOT gate
wire nor_out;
assign nor_out = ~(in1 | in2); // NOR operation
assign out = ~nor_out; // Inverting the NOR output to get the AND with inversion behavior

endmodule