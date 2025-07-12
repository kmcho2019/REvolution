module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Stage registers for 32-bit slices
    reg [31:0] stageA0, stageB0;
    reg [31:0] stageA1, stageB1;

    // Carry registers between stages
    reg        carry0, carry1;

    // Sum registers for each stage (33 bits to hold carry out)
    reg [32:0] sum0;
    reg [32:0] sum1;

    // Pipeline registers for input enable to output enable
    reg i_en_d1, i_en_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stageA0 <= 32'b0;
            stageB0 <= 32'b0;
            stageA1 <= 32'b0;
            stageB1 <= 32'b0;

            carry0 <= 1'b0;
            carry1 <= 1'b0;

            sum0 <= 33'b0;
            sum1 <= 33'b0;

            i_en_d1 <= 1'b0;
            i_en_d2 <= 1'b0;

            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Pipeline input enable
            i_en_d1 <= i_en;
            i_en_d2 <= i_en_d1;

            // Stage 0: latch lower 32 bits and add
            if (i_en) begin
                stageA0 <= adda[31:0];
                stageB0 <= addb[31:0];
                carry0 <= 1'b0;  // initial carry zero for new input
            end
            sum0 <= {1'b0, stageA0} + {1'b0, stageB0} + carry0;

            // Stage 1: latch upper 32 bits and add with carry from stage0
            if (i_en_d1) begin
                stageA1 <= adda[63:32];
                stageB1 <= addb[63:32];
                carry1 <= sum0[32];
            end
            sum1 <= {1'b0, stageA1} + {1'b0, stageB1} + carry1;

            // Output assignment when final stage valid
            if (i_en_d2) begin
                result <= {sum1[32], sum1[31:0], sum0[31:0]};
            end

            // Output enable delayed input enable by 2 cycles
            o_en <= i_en_d2;
        end
    end

endmodule