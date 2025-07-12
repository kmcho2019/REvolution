module TopModule(
    input  in1,
    input  in2,
    output out
);

// Direct implementation of the NOR gate using logical operators
// Considering PPA metrics for potential optimizations
assign out = ~(in1 | in2);

endmodule