module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Barrel shifter implementation
    wire [255:0] shifted = in >> sel;
    
    // Output is the LSB of the shifted result
    assign out = shifted[0];

endmodule