module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);
    // Parameters for pipeline stages
    localparam STAGES = 4;
    localparam STAGE_WIDTH = 16;

    // Pipeline registers for operands and enable signals at each stage
    reg [63:0] adda_stage [0:STAGES];
    reg [63:0] addb_stage [0:STAGES];
    reg        en_stage   [0:STAGES];

    // Carry registers between stages
    reg carry_stage [0:STAGES];

    // Partial sums registers for each stage
    reg [STAGE_WIDTH-1:0] sum_stage [0:STAGES-1];

    // Wires for combinational addition results including carry-out for each stage
    wire [STAGE_WIDTH:0] add_result [0:STAGES-1];

    // Assign input stage registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_stage[0] <= 64'd0;
            addb_stage[0] <= 64'd0;
            en_stage[0]   <= 1'b0;
            carry_stage[0]<= 1'b0;  // initial carry in = 0
        end else begin
            adda_stage[0] <= adda;
            addb_stage[0] <= addb;
            en_stage[0]   <= i_en;
            carry_stage[0]<= 1'b0;
        end
    end

    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : adder_stages
            wire [STAGE_WIDTH-1:0] a_part = adda_stage[i][i*STAGE_WIDTH +: STAGE_WIDTH];
            wire [STAGE_WIDTH-1:0] b_part = addb_stage[i][i*STAGE_WIDTH +: STAGE_WIDTH];

            assign add_result[i] = a_part + b_part + carry_stage[i];
        end
    endgenerate

    // Pipeline registers for stages 0 to STAGES-1 sums and next carry and inputs to next stage registers
    // Note: stages 1 to STAGES pipeline registers update below
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 1; j <= STAGES; j = j + 1) begin
                adda_stage[j] <= 64'd0;
                addb_stage[j] <= 64'd0;
                en_stage[j]   <= 1'b0;
                carry_stage[j] <= 1'b0;
            end
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_stage[j] <= {STAGE_WIDTH{1'b0}};
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // For stages 0 to STAGES-1, capture sums and next carry stage
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_stage[j] <= add_result[j][STAGE_WIDTH-1:0];
                // avoid out of bound carry assignment for last stage carry_stage[STAGES]
                if (j < STAGES - 1) begin
                    carry_stage[j+1] <= add_result[j][STAGE_WIDTH];
                end else begin
                    // For last stage, capture carry out in carry_stage[STAGES]
                    carry_stage[STAGES] <= add_result[j][STAGE_WIDTH];
                end
            end

            // Pipeline the operands and enable signals to next stages (1 to STAGES)
            for (j = 1; j <= STAGES; j = j + 1) begin
                adda_stage[j] <= adda_stage[j-1];
                addb_stage[j] <= addb_stage[j-1];
                en_stage[j]   <= en_stage[j-1];
            end

            // When final stage enable is high, assemble the output and set o_en
            if (en_stage[STAGES]) begin
                // Concatenate partial sums from lowest stage 0 (LSB) to highest stage 3 (MSB), plus final carry out
                result <= {carry_stage[STAGES], 
                           sum_stage[STAGES-1], 
                           sum_stage[STAGES-2], 
                           sum_stage[STAGES-3], 
                           sum_stage[0]};
                o_en <= 1'b1;
            end else begin
                result <= 65'd0;
                o_en <= 1'b0;
            end
        end
    end

endmodule