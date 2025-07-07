module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  reg [64:0] result,
    output  reg        o_en
);

// Parameters for pipeline stages
// Let's split 64 bits into 4 stages of 16 bits each for balanced pipeline depth
localparam STAGE_NUM = 4;
localparam STAGE_WIDTH = 16;

// Pipeline registers for operands and carry
reg [STAGE_WIDTH-1:0] adda_pipe [0:STAGE_NUM-1];
reg [STAGE_WIDTH-1:0] addb_pipe [0:STAGE_NUM-1];
reg carry_pipe [0:STAGE_NUM]; // carry_pipe[0] is initial carry-in (0), carry_pipe[STAGE_NUM] is final carry out

// Pipeline registers for partial sums
reg [STAGE_WIDTH-1:0] sum_pipe [0:STAGE_NUM-1];

// Pipeline registers for enable signals
reg [STAGE_NUM:0] en_pipe;

// Initialize carry_in to zero
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        carry_pipe[0] <= 1'b0;
        en_pipe <= 0;
    end else begin
        // Pipeline the enable signal
        en_pipe <= {en_pipe[STAGE_NUM-1:0], i_en};
        // Initial carry_in is always zero at stage 0
        carry_pipe[0] <= 1'b0;
    end
end

integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < STAGE_NUM; i = i + 1) begin
            adda_pipe[i] <= 0;
            addb_pipe[i] <= 0;
            sum_pipe[i] <= 0;
            carry_pipe[i+1] <= 0;
        end
        result <= 0;
        o_en <= 0;
    end else begin
        // Stage 0: latch inputs when i_en is high
        if (i_en) begin
            adda_pipe[0] <= adda[STAGE_WIDTH-1:0];
            addb_pipe[0] <= addb[STAGE_WIDTH-1:0];
        end else begin
            // Hold previous values if no new input
            adda_pipe[0] <= adda_pipe[0];
            addb_pipe[0] <= addb_pipe[0];
        end

        // Compute sum and carry for stage 0
        {carry_pipe[1], sum_pipe[0]} <= adda_pipe[0] + addb_pipe[0] + carry_pipe[0];

        // For stages 1 to STAGE_NUM-1
        for (i = 1; i < STAGE_NUM; i = i + 1) begin
            // Latch inputs for stage i from inputs delayed by i cycles
            if (en_pipe[i-1]) begin
                adda_pipe[i] <= adda[STAGE_WIDTH*(i+1)-1 : STAGE_WIDTH*i];
                addb_pipe[i] <= addb[STAGE_WIDTH*(i+1)-1 : STAGE_WIDTH*i];
            end else begin
                adda_pipe[i] <= adda_pipe[i];
                addb_pipe[i] <= addb_pipe[i];
            end

            // Compute sum and carry for stage i
            {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
        end

        // When the last stage is done, assemble the final result
        if (en_pipe[STAGE_NUM-1]) begin
            result <= {carry_pipe[STAGE_NUM], sum_pipe[STAGE_NUM-1], sum_pipe[STAGE_NUM-2], sum_pipe[STAGE_NUM-3], sum_pipe[0]};
        end else begin
            result <= result;
        end

        // Output enable is the last pipeline stage enable
        o_en <= en_pipe[STAGE_NUM];
    end
end

endmodule