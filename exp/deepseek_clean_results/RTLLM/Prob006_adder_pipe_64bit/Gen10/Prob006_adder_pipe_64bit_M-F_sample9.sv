module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] stage1_a, stage1_b;
reg [20:0] sum_stage1;  // bits 0-20 + carry (21 bits)
reg [21:0] sum_stage2;  // bits 21-42 + carry (22 bits)
reg [20:0] sum_stage3;  // bits 43-63 + carry (21 bits)
reg [2:0] en_pipe;

// Stage 1: Add bits 0-20 (21 bits)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        sum_stage1 <= 21'b0;
        en_pipe <= 3'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        en_pipe <= {en_pipe[1:0], i_en};
        sum_stage1 <= {1'b0, adda[20:0]} + {1'b0, addb[20:0]};
    end
end

// Stage 2: Add bits 21-42 (22 bits) with carry from stage1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2 <= 22'b0;
    end else begin
        sum_stage2 <= {1'b0, stage1_a[42:21]} + {1'b0, stage1_b[42:21]} + sum_stage1[20];
    end
end

// Stage 3: Add bits 43-63 (21 bits) with carry from stage2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3 <= 21'b0;
    end else begin
        sum_stage3 <= {1'b0, stage1_a[63:43]} + {1'b0, stage1_b[63:43]} + sum_stage2[21];
    end
end

// Final output assembly
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {sum_stage3[20:0], sum_stage2[20:0], sum_stage1[19:0]};
        result[64] <= sum_stage3[20]; // Final carry out
        o_en <= en_pipe[2];
    end
end

endmodule