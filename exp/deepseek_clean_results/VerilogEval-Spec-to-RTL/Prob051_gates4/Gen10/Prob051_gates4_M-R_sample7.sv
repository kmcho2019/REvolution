module TopModule(
    input  wire [3:0] in,
    output reg       out_and,
    output reg       out_or,
    output reg       out_xor
);

    always @(*) begin
        // 4-input AND implemented as chained bitwise AND
        out_and = in[0] & in[1] & in[2] & in[3];
        
        // 4-input OR implemented as chained bitwise OR
        out_or  = in[0] | in[1] | in[2] | in[3];
        
        // 4-input XOR implemented as chained bitwise XOR
        out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];
    end

endmodule