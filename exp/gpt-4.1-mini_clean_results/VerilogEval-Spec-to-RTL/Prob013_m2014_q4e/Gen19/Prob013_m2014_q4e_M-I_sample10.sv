module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly implement 2-input NOR with single-level assign statement for optimal PPA
    assign out = ~(in1 | in2);
endmodule