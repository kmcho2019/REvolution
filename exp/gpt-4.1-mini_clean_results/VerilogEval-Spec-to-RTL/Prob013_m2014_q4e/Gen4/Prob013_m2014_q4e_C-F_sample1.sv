module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Output is high only when both inputs are low: 2-input NOR gate
    assign out = ~(in1 | in2);
endmodule