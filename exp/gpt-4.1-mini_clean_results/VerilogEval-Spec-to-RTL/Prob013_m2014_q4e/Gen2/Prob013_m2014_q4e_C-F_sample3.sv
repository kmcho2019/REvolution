module TopModule(
    input  wire in1,
    input  wire in2,
    output wire out
);

    // Intermediate OR result, declared locally within assign for clarity but no explicit wire
    assign out = ~(in1 | in2);

endmodule