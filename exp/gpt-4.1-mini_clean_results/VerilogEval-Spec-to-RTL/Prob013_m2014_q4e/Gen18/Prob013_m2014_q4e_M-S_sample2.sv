module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Direct 2-input NOR implementation without extra module instantiation
    assign out = ~(in1 | in2);
endmodule