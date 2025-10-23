module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STG_WIDTH = 8;
    localparam STAGES = 64 / STG_WIDTH; // 8 stages

    // Pipeline registers for each stage:
    // Registered operand slices
    reg [STG_WIDTH-1:0] adda_reg [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_reg [0:STAGES-1];

    // Registered sum output per stage
    reg [STG_WIDTH-1:0] sum_reg [0:STAGES-1];

    // Registered carry signals between stages
    reg carry_reg [0:STAGES]; // carry_reg[0] is initial carry-in = 0

    // Enable signal pipeline to track valid data
    reg en_reg [0:STAGES];

    integer i;

    // On reset or clock, update pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline regs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_reg[i] <= {STG_WIDTH{1'b0}};
                addb_reg[i] <= {STG_WIDTH{1'b0}};
                sum_reg[i] <= {STG_WIDTH{1'b0}};
                carry_reg[i] <= 1'b0;
                en_reg[i] <= 1'b0;
            end
            carry_reg[STAGES] <= 1'b0;
            en_reg[STAGES] <= 1'b0;

            result <= {65{1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: load operand slices and carry-in = 0
            adda_reg[0] <= adda[STG_WIDTH-1:0];
            addb_reg[0] <= addb[STG_WIDTH-1:0];
            carry_reg[0] <= 1'b0;
            en_reg[0] <= i_en;

            // Add stage 0 slice + carry in
            {carry_reg[1], sum_reg[0]} <= adda_reg[0] + addb_reg[0] + carry_reg[0];

            // For stages 1 to STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                // Pipeline next operand slices
                adda_reg[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_reg[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                // Register carry_in from previous stage
                // Add operands and carry_in
                {carry_reg[i+1], sum_reg[i]} <= adda_reg[i] + addb_reg[i] + carry_reg[i];
                // Propagate enable
                en_reg[i] <= en_reg[i-1];
            end

            // Pipeline the last stage enable
            en_reg[STAGES] <= en_reg[STAGES-1];

            // Compose final 65-bit result concatenating sum parts and carry out
            // Since sum_reg and carry_reg are registers, create a temporary wire for concatenation
            // We'll update output registers result and o_en on each clock
            result <= {carry_reg[STAGES],
                       sum_reg[STAGES-1],
                       sum_reg[STAGES-2],
                       sum_reg[STAGES-3],
                       sum_reg[STAGES-4],
                       sum_reg[STAGES-5],
                       sum_reg[STAGES-6],
                       sum_reg[STAGES-7],
                       sum_reg[0]};
            o_en <= en_reg[STAGES];
        end
    end

endmodule