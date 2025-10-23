module TopModule(
    input  in1,
    input  in2,
    output out
);

assign out = ~(in1 | in2);

// Alternative implementation using a single NOR gate primitive (if available)
// assign out = ~(|in1, in2);

// Alternative implementation using basic logic gates
// assign out = ~(in1 | in2);

endmodule