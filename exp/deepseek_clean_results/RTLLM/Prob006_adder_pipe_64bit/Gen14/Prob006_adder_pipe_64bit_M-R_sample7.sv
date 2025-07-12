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
reg [63:0] stage1_a, stage1_b;
wire [64:0] stage1_sum = {1'b0, adda} + {1'b0, addb};

// Pipeline stage 2 registers
reg [63:0] stage2_a, stage2_b;
reg [64:0] stage2_sum;

// Pipeline stage 3 registers
reg [64:0] stage3_sum;

// Enable signal pipeline
reg [2:0] enable_pipe;

// Stage 1: Input registers and combinational sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
    end
end

// Stage 2: Pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_a <= 64'b0;
        stage2_b <= 64'b0;
        stage2_sum <= 65'b0;
    end else begin
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
        stage2_sum <= stage1_sum;
    end
end

// Stage 3: Output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_sum <= 65'b0;
        result <= 65'b0;
    end else begin
        stage3_sum <= {1'b0, stage2_a} + {1'b0, stage2_b};
        result <= stage3_sum;
    end
end

// Enable signal pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        enable_pipe <= 3'b0;
        o_en <= 1'b0;
    end else begin
        enable_pipe <= {enable_pipe[1:0], i_en};
        o_en <= enable_pipe[2];
    end
end

endmodule