module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimized population count using shared logic
    wire sum = in[0] ^ in[1];
    wire carry = in[0] & in[1];
    
    assign out[0] = sum ^ in[2];
    assign out[1] = carry | (sum & in[2]);
endmodule