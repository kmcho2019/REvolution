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
reg [31:0] stage1_sum;
reg [15:0] stage2_sum;
reg [15:0] stage3_sum;
reg stage1_carry, stage2_carry;
reg [2:0] enable_pipe;

// Adder segments
wire [32:0] sum_low = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};
wire [32:0] sum_mid = {1'b0, adda[47:32]} + {1'b0, addb[47:32]} + stage1_carry;
wire [16:0] sum_high = {1'b0, adda[63:48]} + {1'b0, addb[63:48]} + stage2_carry;

// Pipeline stage 1 (low 32 bits)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= 32'b0;
        stage1_carry <= 1'b0;
    end else begin
        stage1_sum <= sum_low[31:0];
        stage1_carry <= sum_low[32];
    end
end

// Pipeline stage 2 (middle 16 bits)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= 16'b0;
        stage2_carry <= 1'b0;
    end else begin
        stage2_sum <= sum_mid[15:0];
        stage2_carry <= sum_mid[16];
    end
end

// Pipeline stage 3 (high 16 bits)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_sum <= 16'b0;
    end else begin
        stage3_sum <= sum_high[15:0];
    end
end

// Enable signal pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        enable_pipe <= 3'b0;
    end else begin
        enable_pipe <= {enable_pipe[1:0], i_en};
    end
end

// Final output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {sum_high[16], stage3_sum, stage2_sum, stage1_sum};
        o_en <= enable_pipe[2];
    end
end

endmodule