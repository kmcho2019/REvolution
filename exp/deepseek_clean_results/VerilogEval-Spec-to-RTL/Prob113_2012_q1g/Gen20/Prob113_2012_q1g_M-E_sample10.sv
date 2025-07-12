module TopModule(
    input [3:0] x,
    output f
);
    // Lookup table mapping each 4-bit input to its output
    // Index format: {x[3],x[2],x[1],x[0]}
    // Ordered from 0000 to 1111 (0 to 15)
    wire [15:0] k_map = 16'b1001_0000_1110_1101;
    
    // Output is simply the selected bit from the lookup table
    assign f = k_map[x];
endmodule