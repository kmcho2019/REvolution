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

    // Pipeline registers for operand slices
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg carry_pipe [0:STAGES];      // carry-in for each stage and final carry-out
    reg en_pipe [0:STAGES];         // enable signal pipelined

    // Partial sums registered per stage
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Combinational sums per stage (8 bits + carry)
    wire [STG_WIDTH:0] add_res [0:STAGES-1];

    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : ADD_STAGES
            assign add_res[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]} + carry_pipe[i];
        end
    endgenerate

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= 0;
                addb_pipe[j] <= 0;
                sum_pipe[j] <= 0;
                carry_pipe[j] <= 0;
                en_pipe[j] <= 0;
            end
            carry_pipe[STAGES] <= 0;
            en_pipe[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0: load lower 8 bits of inputs and initial carry 0
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Stages 1 to 7: load next 8-bit chunks and propagate carry and enable
            for (j = 1; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= adda[j*STG_WIDTH +: STG_WIDTH];
                addb_pipe[j] <= addb[j*STG_WIDTH +: STG_WIDTH];
                carry_pipe[j] <= add_res[j-1][STG_WIDTH]; // carry from previous stage
                en_pipe[j] <= en_pipe[j-1];
            end

            // Register partial sums per stage
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_pipe[j] <= add_res[j][STG_WIDTH-1:0];
            end

            // Register final carry-out and output enable
            carry_pipe[STAGES] <= add_res[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Assemble full 65-bit sum: concatenate partial sums and final carry out
            result <= {carry_pipe[STAGES], 
                       sum_pipe[STAGES-1], 
                       sum_pipe[STAGES-2], 
                       sum_pipe[STAGES-3], 
                       sum_pipe[STAGES-4], 
                       sum_pipe[STAGES-5], 
                       sum_pipe[STAGES-6], 
                       sum_pipe[STAGES-7], 
                       sum_pipe[0]};
            // But above concatenation is out of order and missing indices; better do a loop:

            // We'll use a generate block to create a combinational wire for the concatenation instead
        end
    end

    // Because result is assigned in sequential block, and sum_pipe and carry_pipe are registers,
    // we need a combinational sum_concat wire to concatenate partial sums in order.

    // Use a combinational function-like generate block for assembly:
    wire [64:0] sum_concat;
    reg [64:0] sum_concat_reg;
    always @(*) begin
        sum_concat = 0;
        for (j = 0; j < STAGES; j = j + 1) begin
            sum_concat[j*STG_WIDTH +: STG_WIDTH] = sum_pipe[j];
        end
        sum_concat[64] = carry_pipe[STAGES];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
            o_en <= 0;
        end else begin
            result <= sum_concat;
            o_en <= en_pipe[STAGES];
        end
    end
endmodule