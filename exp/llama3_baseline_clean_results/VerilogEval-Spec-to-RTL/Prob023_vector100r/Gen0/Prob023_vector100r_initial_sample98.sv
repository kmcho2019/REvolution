module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    assign out = {<<{in}}; // This will reverse the bits of the input

endmodule