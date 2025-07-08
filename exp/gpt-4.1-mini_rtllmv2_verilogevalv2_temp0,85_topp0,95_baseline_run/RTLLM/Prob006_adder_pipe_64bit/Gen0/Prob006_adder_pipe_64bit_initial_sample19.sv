module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  reg [64:0]  result,
    output  reg         o_en
);

    // Parameters for pipeline stages
    localparam STAGE_NUM = 8;
    localparam STAGE_WIDTH = 8;

    // Stage registers for operands
    reg [63:0] adda_pipe [0:STAGE_NUM];
    reg [63:0] addb_pipe [0:STAGE_NUM];
    reg        en_pipe   [0:STAGE_NUM];

    // Carry registers between stages
    reg [STAGE_NUM:0] carry;
    // Sum registers for each stage partial sums
    reg [STAGE_WIDTH-1:0] sum_stage [0:STAGE_NUM-1];

    integer i;

    // Initialize/reset pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= STAGE_NUM; i = i + 1) begin
                adda_pipe[i] <= 64'b0;
                addb_pipe[i] <= 64'b0;
                en_pipe[i]   <= 1'b0;
            end
            carry <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Propagate inputs and enable through pipeline registers
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0]   <= i_en;

            for (i = 1; i <= STAGE_NUM; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i]   <= en_pipe[i-1];
            end

            // Initialize carry in for first stage
            carry[0] <= 1'b0;

            // Process each stage: 8 bits at a time
            for (i = 0; i < STAGE_NUM; i = i + 1) begin
                // Extract 8-bit parts from the pipelined operands
                // Calculate sum and carry for this stage
                {carry[i+1], sum_stage[i]} <= adda_pipe[i][(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH] 
                                            + addb_pipe[i][(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH] 
                                            + carry[i];
            end

            // Assemble final result from partial sums and final carry out
            // sum_stage contains 8-bit sums of each pipeline stage
            // We update result and output enable only when the last pipeline stage enable is high
            if (en_pipe[STAGE_NUM]) begin
                result <= {carry[STAGE_NUM], 
                           sum_stage[7], 
                           sum_stage[6], 
                           sum_stage[5], 
                           sum_stage[4], 
                           sum_stage[3], 
                           sum_stage[2], 
                           sum_stage[1], 
                           sum_stage[0]};
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

endmodule