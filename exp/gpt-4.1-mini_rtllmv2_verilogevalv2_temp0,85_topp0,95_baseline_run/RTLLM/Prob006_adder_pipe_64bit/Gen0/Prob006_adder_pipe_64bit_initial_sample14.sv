module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input  [63:0]   adda,
    input  [63:0]   addb,
    output reg [64:0] result,
    output reg      o_en
);

// Parameters for pipeline stage widths and count
localparam STAGE_WIDTH = 16;
localparam STAGE_NUM = 64 / STAGE_WIDTH; // 4 stages

// Pipeline registers for inputs, sums and carry
reg [STAGE_WIDTH-1:0] adda_pipe   [0:STAGE_NUM-1];
reg [STAGE_WIDTH-1:0] addb_pipe   [0:STAGE_NUM-1];
reg                   i_en_pipe   [0:STAGE_NUM];

// Pipeline registers for carry signals
reg carry [0:STAGE_NUM];

// Pipeline registers for sum outputs
reg [STAGE_WIDTH-1:0] sum_pipe [0:STAGE_NUM-1];

integer i;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        // Reset pipeline registers
        for(i = 0; i < STAGE_NUM; i = i+1) begin
            adda_pipe[i] <= 0;
            addb_pipe[i] <= 0;
            sum_pipe[i]  <= 0;
        end
        for(i = 0; i <= STAGE_NUM; i = i+1) begin
            i_en_pipe[i] <= 0;
            carry[i]     <= 0;
        end
        result <= 0;
        o_en <= 0;
    end else begin
        // Shift input operands and enable through pipeline registers
        adda_pipe[0] <= adda[15:0];
        addb_pipe[0] <= addb[15:0];
        i_en_pipe[0] <= i_en;

        for(i = 1; i < STAGE_NUM; i = i+1) begin
            adda_pipe[i] <= adda[(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
            addb_pipe[i] <= addb[(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
            i_en_pipe[i] <= i_en_pipe[i-1];
        end
        i_en_pipe[STAGE_NUM] <= i_en_pipe[STAGE_NUM-1];

        // Compute sums and carries for each stage
        carry[0] <= 0;
        for(i = 0; i < STAGE_NUM; i = i+1) begin
            {carry[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry[i];
        end

        // Register result and output enable at last stage
        if(i_en_pipe[STAGE_NUM]) begin
            result <= {carry[STAGE_NUM], sum_pipe[STAGE_NUM-1], sum_pipe[STAGE_NUM-2], sum_pipe[STAGE_NUM-3], sum_pipe[STAGE_NUM-4]};
        end else begin
            result <= result;
        end

        o_en <= i_en_pipe[STAGE_NUM];
    end
end

endmodule