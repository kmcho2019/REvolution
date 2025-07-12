module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Perform NOR operation: output is high only if both inputs are low
    assign out = ~(in1 | in2);
endmodule