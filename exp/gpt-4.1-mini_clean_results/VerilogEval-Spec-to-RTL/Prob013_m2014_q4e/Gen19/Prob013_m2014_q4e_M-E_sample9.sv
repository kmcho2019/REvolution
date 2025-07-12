module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Use bitwise NOR operator directly for minimal logic and delay
    assign out = ~(in1 | in2);
endmodule