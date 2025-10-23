module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    // Direct NOR operation using continuous assignment
    assign out = ~(in1 | in2);
endmodule