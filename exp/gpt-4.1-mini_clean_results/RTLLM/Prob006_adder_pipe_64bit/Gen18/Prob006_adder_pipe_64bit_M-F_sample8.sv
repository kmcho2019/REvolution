module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)(
    input                      clk,
    input                      rst_n,
    input                      i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0]   result,
    output reg                 o_en
);

    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    // Stage registers for operands
    reg [STG_WIDTH-1:0] adda_stage [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_stage [0:NUM_STAGES-1];

    // Partial sum and carry registers for each stage
    reg [STG_WIDTH-1:0] sum_stage [0:NUM_STAGES-1];
    reg                 carry_stage [0:NUM_STAGES];

    // Pipeline valid enable signals for each stage
    reg valid_stage [0:NUM_STAGES];

    integer i;

    // Break down adda and addb inputs into stage slices when i_en asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_stage[i] <= {STG_WIDTH{1'b0}};
                addb_stage[i] <= {STG_WIDTH{1'b0}};
                sum_stage[i] <= {STG_WIDTH{1'b0}};
                carry_stage[i] <= 1'b0;
                valid_stage[i] <= 1'b0;
            end
            carry_stage[NUM_STAGES] <= 1'b0;
            valid_stage[NUM_STAGES] <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 (loading operands)
            valid_stage[0] <= i_en;
            carry_stage[0] <= 1'b0; // initial carry-in zero

            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_stage[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_stage[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end
            end

            // Perform addition for each stage sequentially with pipeline registers
            // First stage addition
            if (valid_stage[0]) begin
                {carry_stage[1], sum_stage[0]} <= adda_stage[0] + addb_stage[0] + carry_stage[0];
            end else begin
                sum_stage[0] <= sum_stage[0];
                carry_stage[1] <= 1'b0;
            end

            // Following stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                // Propagate valid signal
                valid_stage[i] <= valid_stage[i-1];
                if (valid_stage[i-1]) begin
                    {carry_stage[i+1], sum_stage[i]} <= adda_stage[i] + addb_stage[i] + carry_stage[i];
                end else begin
                    sum_stage[i] <= sum_stage[i];
                    carry_stage[i+1] <= 1'b0;
                end
            end

            // Propagate final valid signal
            valid_stage[NUM_STAGES] <= valid_stage[NUM_STAGES-1];

            // When last stage valid, pack results and output
            if (valid_stage[NUM_STAGES]) begin
                // Concatenate sums from all stages plus final carry out
                result <= {carry_stage[NUM_STAGES],
                           sum_stage[NUM_STAGES-1],
                           sum_stage[NUM_STAGES-2],
                           sum_stage[NUM_STAGES-3],
                           sum_stage[NUM_STAGES-4]};
                // Above concatenation is written fixed for 4 stages, 
                // but better to do it dynamically for generic NUM_STAGES:
                // We'll build a temporary vector dynamically:
                //
                // To support generic NUM_STAGES, use a loop to pack sums:
                //
                // We cannot use a generate block inside procedural always,
                // so we will create a combinational function for concatenation.

            end
            o_en <= valid_stage[NUM_STAGES];
        end
    end

    // Pack sum outputs dynamically for generic NUM_STAGES
    reg [DATA_WIDTH-1:0] sum_concat;
    integer j;
    always @(*) begin
        sum_concat = {DATA_WIDTH{1'b0}};
        for (j = 0; j < NUM_STAGES; j = j + 1) begin
            sum_concat[j*STG_WIDTH +: STG_WIDTH] = sum_stage[j];
        end
    end

    // Assign result with carry and sum_concat at every clock posedge when valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            if (valid_stage[NUM_STAGES]) begin
                result <= {carry_stage[NUM_STAGES], sum_concat};
            end
            o_en <= valid_stage[NUM_STAGES];
        end
    end

endmodule