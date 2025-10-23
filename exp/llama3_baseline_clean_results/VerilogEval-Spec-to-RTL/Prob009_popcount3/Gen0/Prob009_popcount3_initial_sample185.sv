module TopModule(
    input  [2:0] in,  // input vector
    output [1:0] out  // output count
);

    // Count the number of '1's in the input vector
    assign out[0] = in[0] ^ in[1] ^ in[2];  // using XOR to check for odd number of '1's in bits 0, 1 and 2 
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);  // using AND and OR to check for two '1's 

endmodule