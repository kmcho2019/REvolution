module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Create a shifted version of the input
    wire [1023:0] shifted_in = in >> (sel * 4);
    
    // Output is the least significant 4 bits of the shifted input
    assign out = shifted_in[3:0];

endmodule