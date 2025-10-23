module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [31:0] lower_a, lower_b;
reg [31:0] upper_a, upper_b;
reg stage1_valid;
reg stage2_valid;

// Computation results
wire [32:0] lower_sum = {1'b0, lower_a} + {1'b0, lower_b};
wire [32:0] upper_sum = {1'b0, upper_a} + {1'b0, upper_b} + lower_sum[32];

// Pipeline stage 1: lower 32 bits
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lower_a <= 32'b0;
        lower_b <= 32'b0;
        stage1_valid <= 1'b0;
    end else if (i_en) begin
        lower_a <= adda[31:0];
        lower_b <= addb[31:0];
        stage1_valid <= 1'b1;
    end else begin
        stage1_valid <= 1'b0;
    end
end

// Pipeline stage 2: upper 32 bits with carry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        upper_a <= 32'b0;
        upper_b <= 32'b0;
        stage2_valid <= 1'b0;
    end else if (stage1_valid) begin
        upper_a <= adda[63:32];
        upper_b <= addb[63:32];
        stage2_valid <= 1'b1;
    end else begin
        stage2_valid <= 1'b0;
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else if (stage2_valid) begin
        result <= {upper_sum[32], upper_sum[31:0], lower_sum[31:0]};
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule