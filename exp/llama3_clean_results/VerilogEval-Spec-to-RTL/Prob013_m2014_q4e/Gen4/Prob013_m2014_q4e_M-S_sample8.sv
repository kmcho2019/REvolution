module TopModule(
    input  in1,
    input  in2,
    output out
);

assign out = ~(in1 | in2); // This is already the simplest form for a NOR operation in Verilog
// Alternatively, for a more direct NOR expression, we recognize that the above is the most straightforward implementation

endmodule