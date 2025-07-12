module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Create a 1028-bit vector by concatenating the input with itself
    // to handle the wrap-around case (sel=255)
    wire [1027:0] extended_in = {in, in[3:0]};
    
    // Shift right by sel*4 bits and take the least significant 4 bits
    assign out = extended_in >> (sel * 4);

endmodule