module TopModule (
    input  [254:0] in,
    output reg [7:0] out
);

    // Stage 1: Count 1s in 3-bit groups (85 groups)
    reg [1:0] stage1 [0:84];
    integer i;
    always @(*) begin
        for (i = 0; i < 85; i = i + 1) begin
            case (i)
                84: stage1[i] = in[254] + in[253] + in[252]; // Last group has 3 bits
                default: stage1[i] = in[i*3+2] + in[i*3+1] + in[i*3];
            endcase
        end
    end

    // Stage 2: Sum adjacent pairs (43 sums) using carry-save
    reg [2:0] stage2 [0:42];
    always @(*) begin
        for (i = 0; i < 42; i = i + 1) begin
            stage2[i] = stage1[i*2] + stage1[i*2+1];
        end
        stage2[42] = stage1[84]; // Handle odd remaining
    end

    // Stage 3: Sum in groups of 4 (11 sums)
    reg [4:0] stage3 [0:10];
    always @(*) begin
        for (i = 0; i < 10; i = i + 1) begin
            stage3[i] = stage2[i*4] + stage2[i*4+1] + stage2[i*4+2] + stage2[i*4+3];
        end
        stage3[10] = stage2[40] + stage2[41] + stage2[42]; // Last group
    end

    // Stage 4: Final summation
    reg [7:0] temp_sum;
    always @(*) begin
        temp_sum = 0;
        for (i = 0; i < 11; i = i + 1) begin
            temp_sum = temp_sum + stage3[i];
        end
        out = temp_sum;
    end

endmodule