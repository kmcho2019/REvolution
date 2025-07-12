module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    assign out = {<< {in}}; // Reverses the bit order of in and assigns it to out

endmodule