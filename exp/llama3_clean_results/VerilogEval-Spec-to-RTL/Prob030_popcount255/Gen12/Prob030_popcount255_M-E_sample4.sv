module TopModule(
    input [254:0] in,
    output [7:0] out
);

    reg [127:0] xor_stage1;
    reg [63:0] xor_stage2;
    reg [31:0] xor_stage3;
    reg [15:0] xor_stage4;
    reg [7:0] xor_stage5;
    reg [7:0] count;

    always @(in) begin
        // Stage 1: XOR adjacent bits
        for (int i = 0; i < 127; i++) begin
            xor_stage1[i] = in[i*2] ^ in[i*2 + 1];
        end
        xor_stage1[127] = in[254];

        // Stage 2: XOR adjacent bits
        for (int i = 0; i < 63; i++) begin
            xor_stage2[i] = xor_stage1[i*2] ^ xor_stage1[i*2 + 1];
        end

        // Stage 3: XOR adjacent bits
        for (int i = 0; i < 31; i++) begin
            xor_stage3[i] = xor_stage2[i*2] ^ xor_stage2[i*2 + 1];
        end

        // Stage 4: XOR adjacent bits
        for (int i = 0; i < 15; i++) begin
            xor_stage4[i] = xor_stage3[i*2] ^ xor_stage3[i*2 + 1];
        end

        // Stage 5: XOR adjacent bits
        for (int i = 0; i < 7; i++) begin
            xor_stage5[i] = xor_stage4[i*2] ^ xor_stage4[i*2 + 1];
        end
        xor_stage5[7] = xor_stage4[15];

        // Count the number of '1's
        count = 8'b0;
        for (int i = 0; i < 8; i++) begin
            count = count + {7'b0, xor_stage5[i]};
        end
    end

    assign out = count;

endmodule