module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    assign out = in[99:0]; // This statement directly reverses the bit order of 'in' and assigns it to 'out'

endmodule