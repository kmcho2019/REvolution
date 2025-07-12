module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Truth-table based population count
    // out[1] = 1 when two or more bits are set
    // out[0] = 1 when odd number of bits are set
    
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);
    assign out[0] = in[0] ^ in[1] ^ in[2];
endmodule