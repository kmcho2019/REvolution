module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // LSB remains optimal XOR reduction
    assign out[0] = ^in;
    
    // MSB: Optimized symmetric majority detection
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule