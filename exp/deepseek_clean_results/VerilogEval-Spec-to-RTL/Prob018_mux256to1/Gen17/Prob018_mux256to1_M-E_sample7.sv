module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Create a one-hot 256-bit vector from the 8-bit sel
    wire [255:0] one_hot = (256'b1 << sel);

    // Bitwise AND with input then OR reduce
    assign out = |(in & one_hot);

endmodule