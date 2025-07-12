module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage parameters
localparam STAGES = 4;
localparam BITS_PER_STAGE = 16;

// Pipeline registers
reg [63:0] a_pipe [0:STAGES-1];
reg [63:0] b_pipe [0:STAGES-1];
reg [STAGES:0] carry_pipe;
reg [STAGES:0] en_pipe;

// Internal signals
wire [64:0] stage_sum [0:STAGES-1];

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : STAGE
        // Each stage computes 16-bit addition with carry in
        assign stage_sum[i] = {1'b0, a_pipe[i][i*BITS_PER_STAGE +: BITS_PER_STAGE]} + 
                             {1'b0, b_pipe[i][i*BITS_PER_STAGE +: BITS_PER_STAGE]} + 
                             carry_pipe[i];
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < STAGES; j = j + 1) begin
            a_pipe[j] <= 64'b0;
            b_pipe[j] <= 64'b0;
        end
        carry_pipe <= {(STAGES+1){1'b0}};
        en_pipe <= {(STAGES+1){1'b0}};
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input registers
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        carry_pipe[0] <= 1'b0;
        en_pipe[0] <= i_en;

        // Pipeline stages 1 through STAGES-1
        for (integer k = 1; k < STAGES; k = k + 1) begin
            a_pipe[k] <= a_pipe[k-1];
            b_pipe[k] <= b_pipe[k-1];
            carry_pipe[k] <= stage_sum[k-1][BITS_PER_STAGE];
            en_pipe[k] <= en_pipe[k-1];
        end

        // Final output stage
        result <= {stage_sum[STAGES-1][63:0], stage_sum[STAGES-1][64]};
        o_en <= en_pipe[STAGES-1];
    end
end

endmodule