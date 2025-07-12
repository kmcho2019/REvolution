module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Create a circular version of the input (concatenated with itself)
    wire [511:0] circular_in = {in, in};
    
    // Select the 256-bit window starting at 'sel' position
    wire [255:0] shifted_window = circular_in[sel +: 256];
    
    // The desired bit is now at position 0 (LSB)
    assign out = shifted_window[0];

endmodule