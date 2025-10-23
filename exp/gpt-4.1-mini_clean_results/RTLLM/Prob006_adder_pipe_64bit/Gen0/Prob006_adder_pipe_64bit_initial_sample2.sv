module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline stage registers
    reg [15:0] stageA0, stageB0;
    reg [15:0] stageA1, stageB1;
    reg [15:0] stageA2, stageB2;
    reg [15:0] stageA3, stageB3;

    reg        carry0;
    reg        carry1;
    reg        carry2;
    reg        carry3;

    reg [16:0] sum0;
    reg [16:0] sum1;
    reg [16:0] sum2;
    reg [16:0] sum3;

    // Pipeline registers for input enable to generate o_en delayed by 4 cycles
    reg i_en_d1, i_en_d2, i_en_d3, i_en_d4;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            stageA0 <= 16'b0;
            stageB0 <= 16'b0;
            stageA1 <= 16'b0;
            stageB1 <= 16'b0;
            stageA2 <= 16'b0;
            stageB2 <= 16'b0;
            stageA3 <= 16'b0;
            stageB3 <= 16'b0;

            carry0 <= 1'b0;
            carry1 <= 1'b0;
            carry2 <= 1'b0;
            carry3 <= 1'b0;

            sum0 <= 17'b0;
            sum1 <= 17'b0;
            sum2 <= 17'b0;
            sum3 <= 17'b0;

            i_en_d1 <= 1'b0;
            i_en_d2 <= 1'b0;
            i_en_d3 <= 1'b0;
            i_en_d4 <= 1'b0;

            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Pipeline the input enable
            i_en_d1 <= i_en;
            i_en_d2 <= i_en_d1;
            i_en_d3 <= i_en_d2;
            i_en_d4 <= i_en_d3;

            // Stage 0: latch inputs and calculate sum and carry out
            if (i_en) begin
                stageA0 <= adda[15:0];
                stageB0 <= addb[15:0];
            end
            sum0 <= {1'b0, stageA0} + {1'b0, stageB0} + carry0;
            carry0 <= i_en ? 1'b0 : carry0; // initial carry is zero on new input

            // Stage 1: latch next 16 bits, add with carry from stage0
            if (i_en_d1) begin
                stageA1 <= adda[31:16];
                stageB1 <= addb[31:16];
            end
            sum1 <= {1'b0, stageA1} + {1'b0, stageB1} + carry1;
            carry1 <= sum0[16];

            // Stage 2: latch next 16 bits, add with carry from stage1
            if (i_en_d2) begin
                stageA2 <= adda[47:32];
                stageB2 <= addb[47:32];
            end
            sum2 <= {1'b0, stageA2} + {1'b0, stageB2} + carry2;
            carry2 <= sum1[16];

            // Stage 3: latch last 16 bits, add with carry from stage2
            if (i_en_d3) begin
                stageA3 <= adda[63:48];
                stageB3 <= addb[63:48];
            end
            sum3 <= {1'b0, stageA3} + {1'b0, stageB3} + carry3;
            carry3 <= sum2[16];

            // Final output assembly at stage4
            if (i_en_d4) begin
                // sum0[15:0], sum1[15:0], sum2[15:0], sum3[15:0] and carry out sum3[16]
                result <= {sum3[16], sum3[15:0], sum2[15:0], sum1[15:0], sum0[15:0]};
            end

            // Output enable is delayed i_en
            o_en <= i_en_d4;
        end
    end

endmodule