module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    assign out = in[99:0]; // Reverse the bit ordering
    // This will assign bit 99 of in to bit 0 of out, bit 98 of in to bit 1 of out, and so on

endmodule