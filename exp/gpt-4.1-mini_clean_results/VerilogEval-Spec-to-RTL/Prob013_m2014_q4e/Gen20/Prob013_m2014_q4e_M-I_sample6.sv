module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly implement NOR with single-level assign to minimize delay, area and power
    assign out = ~(in1 | in2);
endmodule