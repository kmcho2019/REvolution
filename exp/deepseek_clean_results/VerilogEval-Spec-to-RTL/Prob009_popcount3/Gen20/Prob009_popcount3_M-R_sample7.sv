module TopModule (
    input [2:0] in,
    output [1:0] out
);

    wire any_two_adjacent = (in[0] & in[1]) | (in[1] & in[2]);
    wire any_two_nonadjacent = in[0] & in[2];
    
    // LSB: 1 when odd number of 1s (same as XOR)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    
    // MSB: 1 when two or more 1s (majority function)
    assign out[1] = any_two_adjacent | any_two_nonadjacent;

endmodule