module TopModule (
    input [7:0] in,
    output reg parity
);
    reg [3:0] first_stage;
    reg [1:0] second_stage;
    
    always @(*) begin
        // First stage: XOR bit pairs
        first_stage[0] = in[0] ^ in[1];
        first_stage[1] = in[2] ^ in[3];
        first_stage[2] = in[4] ^ in[5];
        first_stage[3] = in[6] ^ in[7];
        
        // Second stage: XOR intermediate results
        second_stage[0] = first_stage[0] ^ first_stage[1];
        second_stage[1] = first_stage[2] ^ first_stage[3];
        
        // Final XOR
        parity = second_stage[0] ^ second_stage[1];
    end
endmodule