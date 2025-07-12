module TopModule (
    input [2:0] in,
    output [1:0] out
);
    wire sum0, carry0;  // First half adder (bits 0 and 1)
    wire sum1, carry1;  // Second half adder (sum0 and bit 2)
    
    // First half adder: in[0] + in[1]
    assign sum0 = in[0] ^ in[1];
    assign carry0 = in[0] & in[1];
    
    // Second half adder: sum0 + in[2]
    assign sum1 = sum0 ^ in[2];
    assign carry1 = sum0 & in[2];
    
    // Final population count
    assign out = {carry0 | carry1, sum1};
endmodule