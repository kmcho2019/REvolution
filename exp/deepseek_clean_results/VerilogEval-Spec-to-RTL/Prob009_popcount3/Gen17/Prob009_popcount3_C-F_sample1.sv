module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // LSB: XOR reduction for efficient odd count detection
    assign out[0] = ^in;
    
    // MSB: Sum of bits with threshold check (clear intent)
    assign out[1] = (in[0] + in[1] + in[2]) >= 2;
endmodule