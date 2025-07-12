module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Stage 1: Input registers
reg [7:0] stage1_a, stage1_b;
reg stage1_en;

// Stage 2: Partial products and first level adders
reg [15:0] pp [7:0];
reg [15:0] stage2_sum_low, stage2_sum_high;
reg stage2_en;

// Stage 3: Final sum
reg [15:0] stage3_sum;
reg stage3_en;

// Generate all partial products
wire [15:0] pp_wire [7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign pp_wire[i] = stage1_b[i] ? ({8'b0, stage1_a} << i) : 16'b0;
    end
endgenerate

// First level adder tree (split into low and high nibbles)
wire [15:0] sum_low = pp_wire[0] + pp_wire[1] + pp_wire[2] + pp_wire[3];
wire [15:0] sum_high = pp_wire[4] + pp_wire[5] + pp_wire[6] + pp_wire[7];

// Pipeline stage 1: Input sampling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 8'b0;
        stage1_b <= 8'b0;
        stage1_en <= 1'b0;
    end else begin
        stage1_a <= mul_en_in ? mul_a : stage1_a;
        stage1_b <= mul_en_in ? mul_b : stage1_b;
        stage1_en <= mul_en_in;
    end
end

// Pipeline stage 2: Partial product accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum_low <= 16'b0;
        stage2_sum_high <= 16'b0;
        stage2_en <= 1'b0;
    end else begin
        for (int j = 0; j < 8; j = j + 1) begin
            pp[j] <= pp_wire[j];
        end
        stage2_sum_low <= sum_low;
        stage2_sum_high <= sum_high;
        stage2_en <= stage1_en;
    end
end

// Pipeline stage 3: Final addition and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_sum <= 16'b0;
        stage3_en <= 1'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        stage3_sum <= stage2_sum_low + stage2_sum_high;
        stage3_en <= stage2_en;
        mul_out <= stage3_en ? stage3_sum : 16'b0;
        mul_en_out <= stage3_en;
    end
end

endmodule