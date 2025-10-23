module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output reg [31:0] out  // 32-bit output vector with bytes reversed
);

    reg [7:0] stage1, stage2, stage3, stage4;

    always @(*) begin
        stage1 = in[31:24];  // Load the most significant byte into stage 1
        stage2 = in[23:16];  // Load the second most significant byte into stage 2
        stage3 = in[15:8];   // Load the third most significant byte into stage 3
        stage4 = in[7:0];    // Load the least significant byte into stage 4

        // Combine the stages to form the output vector with reversed byte order
        out = {stage4, stage3, stage2, stage1};
    end

endmodule