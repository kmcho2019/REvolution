module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Direct 2-input NOR gate implementation for minimal area and power
    assign out = ~(in1 | in2);
endmodule