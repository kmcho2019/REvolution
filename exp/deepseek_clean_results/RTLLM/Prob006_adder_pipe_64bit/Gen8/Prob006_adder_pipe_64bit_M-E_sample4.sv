module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Phase 1 registers
reg [63:0] phase1_a, phase1_b;
reg [15:0] sum0_0, sum0_1;  // Segment 0 (LSB) with carry=0 and carry=1
reg [15:0] sum1_0, sum1_1;  // Segment 1
reg [15:0] sum2_0, sum2_1;  // Segment 2
reg [15:0] sum3_0, sum3_1;  // Segment 3 (MSB)
reg [3:0]  carry_gen;       // Carry generate bits for each segment
reg [1:0]  en_pipe;

// Phase 2 signals
wire [3:0] carry_chain;
wire [16:0] seg0_sum;
wire [16:0] seg1_sum;
wire [16:0] seg2_sum;
wire [16:0] seg3_sum;

// Phase 1: Parallel computation of all possible sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase1_a <= 64'b0;
        phase1_b <= 64'b0;
        {sum0_0, sum0_1} <= {16'b0, 16'b0};
        {sum1_0, sum1_1} <= {16'b0, 16'b0};
        {sum2_0, sum2_1} <= {16'b0, 16'b0};
        {sum3_0, sum3_1} <= {16'b0, 16'b0};
        carry_gen <= 4'b0;
        en_pipe <= 2'b0;
    end else if (i_en) begin
        phase1_a <= adda;
        phase1_b <= addb;
        
        // Compute all segment sums in parallel
        sum0_0 <= adda[15:0] + addb[15:0];
        sum0_1 <= adda[15:0] + addb[15:0] + 1'b1;
        
        sum1_0 <= adda[31:16] + addb[31:16];
        sum1_1 <= adda[31:16] + addb[31:16] + 1'b1;
        
        sum2_0 <= adda[47:32] + addb[47:32];
        sum2_1 <= adda[47:32] + addb[47:32] + 1'b1;
        
        sum3_0 <= adda[63:48] + addb[63:48];
        sum3_1 <= adda[63:48] + addb[63:48] + 1'b1;
        
        // Generate carry signals for each segment
        carry_gen[0] <= (adda[15:0] + addb[15:0]) >> 16;
        carry_gen[1] <= (adda[31:16] + addb[31:16]) >> 16;
        carry_gen[2] <= (adda[47:32] + addb[47:32]) >> 16;
        carry_gen[3] <= (adda[63:48] + addb[63:48]) >> 16;
        
        en_pipe <= {en_pipe[0], i_en};
    end
end

// Phase 2: Carry resolution and result selection
assign carry_chain[0] = carry_gen[0];
assign carry_chain[1] = carry_gen[1] | (carry_chain[0] & (phase1_a[15:0] + phase1_b[15:0] == 16'hFFFF));
assign carry_chain[2] = carry_gen[2] | (carry_chain[1] & (phase1_a[31:16] + phase1_b[31:16] == 16'hFFFF));
assign carry_chain[3] = carry_gen[3] | (carry_chain[2] & (phase1_a[47:32] + phase1_b[47:32] == 16'hFFFF));

assign seg0_sum = {1'b0, carry_chain[0] ? sum0_1 : sum0_0};
assign seg1_sum = {1'b0, carry_chain[1] ? sum1_1 : sum1_0} + (carry_chain[0] ? 17'h1_0000 : 17'b0);
assign seg2_sum = {1'b0, carry_chain[2] ? sum2_1 : sum2_0} + (carry_chain[1] ? 17'h1_0000 : 17'b0);
assign seg3_sum = {1'b0, carry_chain[3] ? sum3_1 : sum3_0} + (carry_chain[2] ? 17'h1_0000 : 17'b0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {seg3_sum[16:0], seg2_sum[15:0], seg1_sum[15:0], seg0_sum[15:0]};
        o_en <= en_pipe[1];
    end
end

endmodule