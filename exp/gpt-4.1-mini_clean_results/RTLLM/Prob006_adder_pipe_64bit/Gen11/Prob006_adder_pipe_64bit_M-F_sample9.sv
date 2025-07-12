module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8,
    parameter STAGES     = DATA_WIDTH / STG_WIDTH
)(
    input                     clk,
    input                     rst_n,
    input                     i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg                o_en
);

    // Pipeline registers for sum outputs (per stage)
    reg [STG_WIDTH-1:0] sum_reg [0:STAGES-1];
    // Pipeline registers for carry signals (per stage), one extra for carry-in to first stage and carry-out of last stage
    reg                 carry_reg [0:STAGES];
    // Pipeline registers for enable signal
    reg                 en_pipe [0:STAGES];

    // Intermediate wires for stage additions (STG_WIDTH+1 bits to hold carry-out)
    wire [STG_WIDTH:0] stage_sum_w [0:STAGES-1];

    integer i;

    // Combinational adders for each stage
    generate
        genvar gi;
        for (gi = 0; gi < STAGES; gi = gi + 1) begin : gen_adders
            // Add STG_WIDTH-bit operands + 1-bit carry_in from previous stage carry_reg
            // Result is STG_WIDTH+1 bits: lower STG_WIDTH bits are sum, MSB is carry_out
            assign stage_sum_w[gi] = adda[gi*STG_WIDTH +: STG_WIDTH] + addb[gi*STG_WIDTH +: STG_WIDTH] + carry_reg[gi];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_reg[i] <= {STG_WIDTH{1'b0}};
                carry_reg[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            // Reset last carry register (carry_reg[STAGES])
            carry_reg[STAGES] <= 1'b0;
            // Reset last enable pipeline register
            en_pipe[STAGES] <= 1'b0;

            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline and register input enable
            en_pipe[0] <= i_en;
            for (i = 1; i <= STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Initialize carry-in for stage 0 to zero (no carry input at adder start)
            carry_reg[0] <= 1'b0;

            // For each stage, register sum and carry_out
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_reg[i] <= stage_sum_w[i][STG_WIDTH-1:0];
                carry_reg[i+1] <= stage_sum_w[i][STG_WIDTH];
            end

            // Assemble output result from registered sum segments and last carry
            // Use a for-loop to build the result vector
            // Use a temporary reg variable to avoid incomplete assignment warning
            reg [DATA_WIDTH:0] result_next;
            for (i = 0; i < STAGES; i = i + 1) begin
                result_next[i*STG_WIDTH +: STG_WIDTH] = sum_reg[i];
            end
            // Append the final carry_out as MSB
            result_next[DATA_WIDTH] = carry_reg[STAGES];

            result <= result_next;

            // Output enable aligned to pipeline depth
            o_en <= en_pipe[STAGES];
        end
    end

endmodule