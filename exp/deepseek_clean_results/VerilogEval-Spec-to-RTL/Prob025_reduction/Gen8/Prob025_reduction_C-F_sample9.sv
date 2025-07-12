module TopModule (
    input [7:0] in,
    output reg parity
);
    always @(*) begin
        // Stage 1: XOR adjacent bits
        wire [3:0] stage1 = {
            in[6] ^ in[7],
            in[4] ^ in[5],
            in[2] ^ in[3],
            in[0] ^ in[1]
        };

        // Stage 2: XOR pairs from stage1
        wire [1:0] stage2 = {
            stage1[2] ^ stage1[3],
            stage1[0] ^ stage1[1]
        };

        // Final XOR
        parity = stage2[0] ^ stage2[1];
    end
endmodule