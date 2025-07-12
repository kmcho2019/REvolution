module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16,
    parameter NUM_STAGES = DATA_WIDTH / STG_WIDTH
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input       [DATA_WIDTH-1:0] adda,
    input       [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]  result,
    output reg                  o_en
);

    // Operand pipeline registers: hold operand slices per stage
    reg [STG_WIDTH-1:0] a_reg   [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] b_reg   [0:NUM_STAGES-1];

    // Sum pipeline registers per stage
    reg [STG_WIDTH-1:0] sum_reg [0:NUM_STAGES-1];

    // Carry pipeline registers: carry_in for stage i is carry_reg[i]
    // carry_reg[NUM_STAGES] is final carry_out
    reg carry_reg [0:NUM_STAGES];

    // Enable pipeline shift register to track valid data through pipeline
    reg [NUM_STAGES:0] en_pipeline;

    // Combinational sum+carry_out for each stage
    wire [STG_WIDTH:0] stage_sum_carry [0:NUM_STAGES-1];

    genvar i;
    generate
        for (i = 0; i < NUM_STAGES; i = i + 1) begin : gen_adder_stages
            assign stage_sum_carry[i] = a_reg[i] + b_reg[i] + carry_reg[i];
        end
    endgenerate

    integer idx;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (idx = 0; idx < NUM_STAGES; idx = idx + 1) begin
                a_reg[idx]     <= {STG_WIDTH{1'b0}};
                b_reg[idx]     <= {STG_WIDTH{1'b0}};
                sum_reg[idx]   <= {STG_WIDTH{1'b0}};
                carry_reg[idx] <= 1'b0;
            end
            carry_reg[NUM_STAGES] <= 1'b0;

            en_pipeline <= {(NUM_STAGES+1){1'b0}};
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline
            en_pipeline <= {en_pipeline[NUM_STAGES-1:0], i_en};

            // Stage 0: latch full operands on i_en
            if (i_en) begin
                // Latch stage 0 operand slices from full inputs
                a_reg[0] <= adda[STG_WIDTH-1:0];
                b_reg[0] <= addb[STG_WIDTH-1:0];
                carry_reg[0] <= 1'b0; // initial carry in zero
            end else begin
                // Hold stage 0 operands and carry_in if no new input
                a_reg[0] <= a_reg[0];
                b_reg[0] <= b_reg[0];
                carry_reg[0] <= carry_reg[0];
            end

            // Sum and carry_out register for stage 0
            sum_reg[0] <= stage_sum_carry[0][STG_WIDTH-1:0];
            carry_reg[1] <= stage_sum_carry[0][STG_WIDTH];

            // For stages 1 to NUM_STAGES-1:
            // Propagate operand slices, sum, and carry synchronously every cycle
            for (idx = 1; idx < NUM_STAGES; idx = idx + 1) begin
                // Propagate operands from previous cycle slice of adda/addb registered at stage0
                // We pipeline operands through registers for timing alignment
                // At cycle when en_pipeline[idx-1] is 1, operands should be valid
                a_reg[idx] <= a_reg[idx];
                b_reg[idx] <= b_reg[idx];

                // On enable signal at previous pipeline stage, latch operand slices from original inputs (to align operands with carry propagation)
                // We will latch operand slices from original inputs when the valid data arrives
                // To avoid the original problem of operand arrival delay, latch all operand slices on i_en at stage0, and then shift the operands forward every cycle
            end

            // Propagate operands pipeline registers from stage0 slices each cycle
            // Because the carry_reg signals depend on previous stage carry_out, we register operands on every cycle to match carry pipeline progress
            // So shift operands from stage0 through pipeline registers synchronously every cycle
            for (idx = 1; idx < NUM_STAGES; idx = idx + 1) begin
                a_reg[idx] <= a_reg[idx-1];
                b_reg[idx] <= b_reg[idx-1];
            end

            // Register sum and carry_out for stages 1 to NUM_STAGES-1
            for (idx = 1; idx < NUM_STAGES; idx = idx + 1) begin
                sum_reg[idx] <= stage_sum_carry[idx][STG_WIDTH-1:0];
                carry_reg[idx+1] <= stage_sum_carry[idx][STG_WIDTH];
            end

            // When output enable stage is asserted, output the full result
            if (en_pipeline[NUM_STAGES]) begin
                // Concatenate final carry and sums from MSB to LSB
                // Note: sum_reg[0] is LSB stage, sum_reg[NUM_STAGES-1] MSB stage
                result <= {carry_reg[NUM_STAGES],
                           sum_reg[NUM_STAGES-1],
                           sum_reg[NUM_STAGES-2],
                           sum_reg[NUM_STAGES-3],
                           sum_reg[NUM_STAGES-4]};
                // If NUM_STAGES > 4, this needs to be generalized below
            end else begin
                result <= result; // hold previous value
            end

            // Output enable delayed by pipeline depth
            o_en <= en_pipeline[NUM_STAGES];
        end
    end

    // To generalize result concatenation for any NUM_STAGES, add a generate block
    // We override the sequential assignment for result above by creating a combinational function
    // But since result is reg assigned inside clocked always, do this:

    // For synthesis and clean code, implement an alternative approach to assign result in a separate always block
    // that uses a packed array concatenation.

    // Therefore, implement an always_comb or combinational block to assemble final sum concatenation,
    // then register it on output cycle

    // This approach simplifies the final concatenation for arbitrary pipeline depths

    wire [DATA_WIDTH-1:0] sum_concat;
    genvar j;
    generate
        for (j = 0; j < NUM_STAGES; j = j + 1) begin : gen_sum_concat
            // Place sum_reg[j] at correct bit position in sum_concat
            assign sum_concat[STG_WIDTH*j +: STG_WIDTH] = sum_reg[j];
        end
    endgenerate

    // Register output result synchronously with clock, updated only when en_pipeline final stage is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            if (en_pipeline[NUM_STAGES]) begin
                result <= {carry_reg[NUM_STAGES], sum_concat};
            end
            o_en <= en_pipeline[NUM_STAGES];
        end
    end

endmodule