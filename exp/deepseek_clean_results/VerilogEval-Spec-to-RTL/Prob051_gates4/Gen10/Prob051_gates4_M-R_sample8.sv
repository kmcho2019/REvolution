module TopModule(
    input [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    always @(*) begin
        // Default values (good practice)
        out_and = 1'b1;
        out_or  = 1'b0;
        out_xor = 1'b0;
        
        // 4-input AND implementation
        out_and = in[0] & in[1] & in[2] & in[3];
        
        // 4-input OR implementation
        out_or = in[0] | in[1] | in[2] | in[3];
        
        // 4-input XOR implementation
        out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];
    end

endmodule