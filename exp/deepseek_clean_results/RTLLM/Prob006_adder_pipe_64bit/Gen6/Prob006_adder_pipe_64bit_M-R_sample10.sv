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
reg [63:0] stage_a, stage_b;
reg [15:0] sum0_reg, sum1_reg, sum2_reg, sum3_reg;
reg carry0_reg, carry1_reg, carry2_reg;
reg en1, en2, en3;

// Combinational logic for each stage
wire [16:0] sum0 = {1'b0, stage_a[15:0]} + {1'b0, stage_b[15:0]};
wire [16:0] sum1 = {1'b0, stage_a[31:16]} + {1'b0, stage_b[31:16]} + carry0_reg;
wire [16:0] sum2 = {1'b0, stage_a[47:32]} + {1'b0, stage_b[47:32]} + carry1_reg;
wire [16:0] sum3 = {1'b0, stage_a[63:48]} + {1'b0, stage_b[63:48]} + carry2_reg;

// Input stage pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_a <= 64'b0;
        stage_b <= 64'b0;
        en1 <= 1'b0;
    end else begin
        stage_a <= adda;
        stage_b <= addb;
        en1 <= i_en;
    end
end

// Stage 1 pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0_reg <= 16'b0;
        carry0_reg <= 1'b0;
        en2 <= 1'b0;
    end else begin
        sum0_reg <= sum0[15:0];
        carry0_reg <= sum0[16];
        en2 <= en1;
    end
end

// Stage 2 pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1_reg <= 16'b0;
        carry1_reg <= 1'b0;
        en3 <= 1'b0;
    end else begin
        sum1_reg <= sum1[15:0];
        carry1_reg <= sum1[16];
        en3 <= en2;
    end
end

// Stage 3 pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2_reg <= 16'b0;
        carry2_reg <= 1'b0;
    end else begin
        sum2_reg <= sum2[15:0];
        carry2_reg <= sum2[16];
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum3_reg <= 16'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        sum3_reg <= sum3[15:0];
        result <= {sum3[16], sum3[15:0], sum2_reg, sum1_reg, sum0_reg};
        o_en <= en3;
    end
end

endmodule