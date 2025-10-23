module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Pipeline registers for operands
    reg [15:0] adda_stage1, addb_stage1;
    reg [15:0] adda_stage2, addb_stage2;
    reg [15:0] adda_stage3, addb_stage3;
    reg [15:0] adda_stage4, addb_stage4;

    // Registers for carry signals between stages
    reg carry_stage1, carry_stage2, carry_stage3, carry_stage4;

    // Registers for sums per stage
    reg [15:0] sum_stage1, sum_stage2, sum_stage3, sum_stage4;

    // Pipeline registers for enable signal
    reg valid_stage1, valid_stage2, valid_stage3, valid_stage4;

    // Combinational sum and carry outputs for each stage
    wire [16:0] adder_out_stage1;
    wire [16:0] adder_out_stage2;
    wire [16:0] adder_out_stage3;
    wire [16:0] adder_out_stage4;

    // Stage 1 adder: operands plus carry_in (always 0)
    assign adder_out_stage1 = {1'b0, adda_stage1} + {1'b0, addb_stage1} + 17'b0;

    // Stage 2 adder: operands plus carry from stage 1
    assign adder_out_stage2 = {1'b0, adda_stage2} + {1'b0, addb_stage2} + {16'b0, carry_stage1};

    // Stage 3 adder: operands plus carry from stage 2
    assign adder_out_stage3 = {1'b0, adda_stage3} + {1'b0, addb_stage3} + {16'b0, carry_stage2};

    // Stage 4 adder: operands plus carry from stage 3
    assign adder_out_stage4 = {1'b0, adda_stage4} + {1'b0, addb_stage4} + {16'b0, carry_stage3};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            adda_stage1 <= 16'd0; addb_stage1 <= 16'd0;
            adda_stage2 <= 16'd0; addb_stage2 <= 16'd0;
            adda_stage3 <= 16'd0; addb_stage3 <= 16'd0;
            adda_stage4 <= 16'd0; addb_stage4 <= 16'd0;

            carry_stage1 <= 1'b0;
            carry_stage2 <= 1'b0;
            carry_stage3 <= 1'b0;
            carry_stage4 <= 1'b0;

            sum_stage1 <= 16'd0;
            sum_stage2 <= 16'd0;
            sum_stage3 <= 16'd0;
            sum_stage4 <= 16'd0;

            valid_stage1 <= 1'b0;
            valid_stage2 <= 1'b0;
            valid_stage3 <= 1'b0;
            valid_stage4 <= 1'b0;

            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 1: Capture inputs and valid
            if (i_en) begin
                adda_stage1 <= adda[15:0];
                addb_stage1 <= addb[15:0];
            end
            valid_stage1 <= i_en;

            // Register sum and carry from stage 1 adder
            sum_stage1 <= adder_out_stage1[15:0];
            carry_stage1 <= adder_out_stage1[16];

            // Stage 2: Capture operands from original inputs if valid_stage1
            if (valid_stage1) begin
                adda_stage2 <= adda[31:16];
                addb_stage2 <= addb[31:16];
            end
            valid_stage2 <= valid_stage1;

            // Register sum and carry from stage 2 adder
            sum_stage2 <= adder_out_stage2[15:0];
            carry_stage2 <= adder_out_stage2[16];

            // Stage 3: Capture operands if valid_stage2
            if (valid_stage2) begin
                adda_stage3 <= adda[47:32];
                addb_stage3 <= addb[47:32];
            end
            valid_stage3 <= valid_stage2;

            // Register sum and carry from stage 3 adder
            sum_stage3 <= adder_out_stage3[15:0];
            carry_stage3 <= adder_out_stage3[16];

            // Stage 4: Capture operands if valid_stage3
            if (valid_stage3) begin
                adda_stage4 <= adda[63:48];
                addb_stage4 <= addb[63:48];
            end
            valid_stage4 <= valid_stage3;

            // Register sum and carry from stage 4 adder
            sum_stage4 <= adder_out_stage4[15:0];
            carry_stage4 <= adder_out_stage4[16];

            // Output result and enable when data is valid at stage 4
            if (valid_stage4) begin
                result <= {carry_stage4, sum_stage4, sum_stage3, sum_stage2, sum_stage1};
            end
            o_en <= valid_stage4;
        end
    end

endmodule