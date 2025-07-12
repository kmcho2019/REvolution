module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Create a shifted version of the input
    wire [255:0] shifted_in = in >> sel;
    
    // The selected bit is now at position 0
    assign out = shifted_in[0];

endmodule