module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

// Parameters defining pipeline stages
// For simplicity, split 64-bit addition into 4 stages of 16-bit each.
// Each stage computes sum of 16 bits and carry-out.

localparam STAGE_NUM = 4;
localparam STAGE_WIDTH = 16;

// Stage registers for operands and carry
reg [STAGE_WIDTH-1:0] adda_reg [0:STAGE_NUM-1];
reg [STAGE_WIDTH-1:0] addb_reg [0:STAGE_NUM-1];
reg carry_in [0:STAGE_NUM]; // carry_in[0] is carry into stage 0 (zero)
reg [STAGE_WIDTH-1:0] sum_reg [0:STAGE_NUM-1];

reg i_en_reg [0:STAGE_NUM]; // pipeline registers for enable signal

integer i;

// Pipeline input registers: stage 0 inputs and i_en
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < STAGE_NUM; i = i +1) begin
            adda_reg[i] <= 0;
            addb_reg[i] <= 0;
            sum_reg[i] <= 0;
        end
        carry_in[0] <= 0;
        for (i=0; i<=STAGE_NUM; i=i+1) i_en_reg[i] <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Stage 0 input registers
        if (i_en) begin
            adda_reg[0] <= adda[15:0];
            addb_reg[0] <= addb[15:0];
        end
        // Pipeline the operands for other stages
        for (i=1; i<STAGE_NUM; i=i+1) begin
            adda_reg[i] <= adda[(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
            addb_reg[i] <= addb[(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
        end

        // Pipeline the enable signal
        i_en_reg[0] <= i_en;

        // Compute sum and carry for each stage in sequence with registers
        // carry_in[0] = 0
        carry_in[0] <= 1'b0;

        // Stage 0 sum and carry
        {carry_in[1], sum_reg[0]} <= adda_reg[0] + addb_reg[0] + carry_in[0];

        // Stage 1 sum and carry
        {carry_in[2], sum_reg[1]} <= adda_reg[1] + addb_reg[1] + carry_in[1];

        // Stage 2 sum and carry
        {carry_in[3], sum_reg[2]} <= adda_reg[2] + addb_reg[2] + carry_in[2];

        // Stage 3 sum and carry
        {carry_in[4], sum_reg[3]} <= adda_reg[3] + addb_reg[3] + carry_in[3];

        // Pipeline enable for subsequent stages
        i_en_reg[1] <= i_en_reg[0];
        i_en_reg[2] <= i_en_reg[1];
        i_en_reg[3] <= i_en_reg[2];
        i_en_reg[4] <= i_en_reg[3];

        // Output register when all stages complete
        if (i_en_reg[4]) begin
            result <= {carry_in[4], sum_reg[3], sum_reg[2], sum_reg[1], sum_reg[0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule