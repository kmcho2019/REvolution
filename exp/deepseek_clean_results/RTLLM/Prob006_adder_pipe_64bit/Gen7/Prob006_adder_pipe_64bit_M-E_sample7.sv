module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage 1 registers
reg [63:0] a_stg1, b_stg1;
reg [15:0] sum0_0, sum0_1;  // Segment 0 with carry 0/1
reg [15:0] sum1_0, sum1_1;  // Segment 1 with carry 0/1
reg [15:0] sum2_0, sum2_1;  // Segment 2 with carry 0/1
reg [15:0] sum3_0, sum3_1;  // Segment 3 with carry 0/1
reg en_stg1;

// Pipeline stage 2 registers
reg [2:0] carry_prop;       // Carry propagation between segments
reg [15:0] sum0_final;      // Final segment 0 sum
reg [15:0] sum1_0_r, sum1_1_r;
reg [15:0] sum2_0_r, sum2_1_r;
reg [15:0] sum3_0_r, sum3_1_r;
reg [1:0] en_pipe;

// Pipeline stage 3 signals
wire [15:0] sum1_final, sum2_final, sum3_final;

// Stage 1: Pre-compute all segment sums with both carry possibilities
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg1 <= 64'b0;
        b_stg1 <= 64'b0;
        {sum0_0, sum0_1} <= {16'b0, 16'b0};
        {sum1_0, sum1_1} <= {16'b0, 16'b0};
        {sum2_0, sum2_1} <= {16'b0, 16'b0};
        {sum3_0, sum3_1} <= {16'b0, 16'b0};
        en_stg1 <= 1'b0;
    end else begin
        a_stg1 <= adda;
        b_stg1 <= addb;
        
        // Segment 0 (bits 15:0)
        sum0_0 <= adda[15:0] + addb[15:0];
        sum0_1 <= adda[15:0] + addb[15:0] + 1'b1;
        
        // Segment 1 (bits 31:16)
        sum1_0 <= adda[31:16] + addb[31:16];
        sum1_1 <= adda[31:16] + addb[31:16] + 1'b1;
        
        // Segment 2 (bits 47:32)
        sum2_0 <= adda[47:32] + addb[47:32];
        sum2_1 <= adda[47:32] + addb[47:32] + 1'b1;
        
        // Segment 3 (bits 63:48)
        sum3_0 <= adda[63:48] + addb[63:48];
        sum3_1 <= adda[63:48] + addb[63:48] + 1'b1;
        
        en_stg1 <= i_en;
    end
end

// Stage 2: Resolve carry propagation between segments
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        carry_prop <= 3'b0;
        sum0_final <= 16'b0;
        {sum1_0_r, sum1_1_r} <= {16'b0, 16'b0};
        {sum2_0_r, sum2_1_r} <= {16'b0, 16'b0};
        {sum3_0_r, sum3_1_r} <= {16'b0, 16'b0};
        en_pipe <= 2'b0;
    end else begin
        // Determine carry out from segment 0
        carry_prop[0] <= (sum0_1[16] | sum0_0[16]);
        sum0_final <= sum0_0[15:0];
        
        // Store other segments for next stage
        sum1_0_r <= sum1_0;
        sum1_1_r <= sum1_1;
        sum2_0_r <= sum2_0;
        sum2_1_r <= sum2_1;
        sum3_0_r <= sum3_0;
        sum3_1_r <= sum3_1;
        
        // Pipeline the enable
        en_pipe <= {en_pipe[0], en_stg1};
    end
end

// Stage 3: Select final results based on resolved carries
assign sum1_final = carry_prop[0] ? sum1_1_r : sum1_0_r;
assign carry_prop[1] = carry_prop[0] ? sum1_1_r[16] : sum1_0_r[16];

assign sum2_final = carry_prop[1] ? sum2_1_r : sum2_0_r;
assign carry_prop[2] = carry_prop[1] ? sum2_1_r[16] : sum2_0_r[16];

assign sum3_final = carry_prop[2] ? sum3_1_r : sum3_0_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {carry_prop[2] ? sum3_1_r[16] : sum3_0_r[16], 
                  sum3_final[15:0], 
                  sum2_final[15:0], 
                  sum1_final[15:0], 
                  sum0_final[15:0]};
        o_en <= en_pipe[1];
    end
end

endmodule