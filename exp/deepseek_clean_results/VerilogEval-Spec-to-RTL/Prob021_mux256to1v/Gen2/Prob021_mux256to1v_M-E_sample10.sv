module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate the rotation amount (sel*4 modulo 1024)
    wire [10:0] rotation = {3'b0, sel} << 2;  // Multiply by 4
    
    // Create the rotated version of the input
    wire [1023:0] rotated_in = (in >> rotation) | (in << (1024 - rotation));
    
    // Output is the least significant 4 bits of the rotated input
    assign out = rotated_in[3:0];
endmodule