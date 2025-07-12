module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);
    // Stage width and number of stages
    localparam STG_WIDTH = 8;
    localparam STAGES = 64 / STG_WIDTH; // 8 stages

    // Stage sum and carry registers
    reg [STG_WIDTH-1:0] sum_stage0, sum_stage1, sum_stage2, sum_stage3;
    reg [STG_WIDTH-1:0] sum_stage4, sum_stage5, sum_stage6, sum_stage7;

    reg carry_stage0, carry_stage1, carry_stage2, carry_stage3;
    reg carry_stage4, carry_stage5, carry_stage6, carry_stage7, carry_stage8; // last carry

    // Enable pipeline registers
    reg en_stage0, en_stage1, en_stage2, en_stage3;
    reg en_stage4, en_stage5, en_stage6, en_stage7, en_stage8;

    // Extract slices of input operands
    wire [STG_WIDTH-1:0] adda0 = adda[ 7: 0];
    wire [STG_WIDTH-1:0] addb0 = addb[ 7: 0];
    wire [STG_WIDTH-1:0] adda1 = adda[15: 8];
    wire [STG_WIDTH-1:0] addb1 = addb[15: 8];
    wire [STG_WIDTH-1:0] adda2 = adda[23:16];
    wire [STG_WIDTH-1:0] addb2 = addb[23:16];
    wire [STG_WIDTH-1:0] adda3 = adda[31:24];
    wire [STG_WIDTH-1:0] addb3 = addb[31:24];
    wire [STG_WIDTH-1:0] adda4 = adda[39:32];
    wire [STG_WIDTH-1:0] addb4 = addb[39:32];
    wire [STG_WIDTH-1:0] adda5 = adda[47:40];
    wire [STG_WIDTH-1:0] addb5 = addb[47:40];
    wire [STG_WIDTH-1:0] adda6 = adda[55:48];
    wire [STG_WIDTH-1:0] addb6 = addb[55:48];
    wire [STG_WIDTH-1:0] adda7 = adda[63:56];
    wire [STG_WIDTH-1:0] addb7 = addb[63:56];

    // Combinational addition results per stage (sum + carry out)
    wire [STG_WIDTH:0] add_res0, add_res1, add_res2, add_res3;
    wire [STG_WIDTH:0] add_res4, add_res5, add_res6, add_res7;

    // Add stage 0 (lowest 8 bits)
    assign add_res0 = {1'b0, adda0} + {1'b0, addb0} + {STG_WIDTH{1'b0}, carry_stage0};
    // Add stage 1
    assign add_res1 = {1'b0, adda1} + {1'b0, addb1} + {STG_WIDTH{1'b0}, carry_stage1};
    // Add stage 2
    assign add_res2 = {1'b0, adda2} + {1'b0, addb2} + {STG_WIDTH{1'b0}, carry_stage2};
    // Add stage 3
    assign add_res3 = {1'b0, adda3} + {1'b0, addb3} + {STG_WIDTH{1'b0}, carry_stage3};
    // Add stage 4
    assign add_res4 = {1'b0, adda4} + {1'b0, addb4} + {STG_WIDTH{1'b0}, carry_stage4};
    // Add stage 5
    assign add_res5 = {1'b0, adda5} + {1'b0, addb5} + {STG_WIDTH{1'b0}, carry_stage5};
    // Add stage 6
    assign add_res6 = {1'b0, adda6} + {1'b0, addb6} + {STG_WIDTH{1'b0}, carry_stage6};
    // Add stage 7 (highest 8 bits)
    assign add_res7 = {1'b0, adda7} + {1'b0, addb7} + {STG_WIDTH{1'b0}, carry_stage7};

    // Pipeline and carry chain logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            sum_stage0 <= 0; sum_stage1 <= 0; sum_stage2 <= 0; sum_stage3 <= 0;
            sum_stage4 <= 0; sum_stage5 <= 0; sum_stage6 <= 0; sum_stage7 <= 0;

            carry_stage0 <= 0; carry_stage1 <= 0; carry_stage2 <= 0; carry_stage3 <= 0;
            carry_stage4 <= 0; carry_stage5 <= 0; carry_stage6 <= 0; carry_stage7 <= 0; carry_stage8 <= 0;

            en_stage0 <= 0; en_stage1 <= 0; en_stage2 <= 0; en_stage3 <= 0;
            en_stage4 <= 0; en_stage5 <= 0; en_stage6 <= 0; en_stage7 <= 0; en_stage8 <= 0;

            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0: Input enable and carry_in = 0
            carry_stage0 <= 1'b0;
            en_stage0 <= i_en;

            // Stage 0 registers
            sum_stage0 <= add_res0[STG_WIDTH-1:0];
            carry_stage1 <= add_res0[STG_WIDTH];
            en_stage1 <= en_stage0;

            // Stage 1 registers
            sum_stage1 <= add_res1[STG_WIDTH-1:0];
            carry_stage2 <= add_res1[STG_WIDTH];
            en_stage2 <= en_stage1;

            // Stage 2 registers
            sum_stage2 <= add_res2[STG_WIDTH-1:0];
            carry_stage3 <= add_res2[STG_WIDTH];
            en_stage3 <= en_stage2;

            // Stage 3 registers
            sum_stage3 <= add_res3[STG_WIDTH-1:0];
            carry_stage4 <= add_res3[STG_WIDTH];
            en_stage4 <= en_stage3;

            // Stage 4 registers
            sum_stage4 <= add_res4[STG_WIDTH-1:0];
            carry_stage5 <= add_res4[STG_WIDTH];
            en_stage5 <= en_stage4;

            // Stage 5 registers
            sum_stage5 <= add_res5[STG_WIDTH-1:0];
            carry_stage6 <= add_res5[STG_WIDTH];
            en_stage6 <= en_stage5;

            // Stage 6 registers
            sum_stage6 <= add_res6[STG_WIDTH-1:0];
            carry_stage7 <= add_res6[STG_WIDTH];
            en_stage7 <= en_stage6;

            // Stage 7 registers (last)
            sum_stage7 <= add_res7[STG_WIDTH-1:0];
            carry_stage8 <= add_res7[STG_WIDTH];
            en_stage8 <= en_stage7;

            // Assemble final result when valid
            result <= {carry_stage8,
                       sum_stage7,
                       sum_stage6,
                       sum_stage5,
                       sum_stage4,
                       sum_stage3,
                       sum_stage2,
                       sum_stage1,
                       sum_stage0};

            o_en <= en_stage8;
        end
    end
endmodule