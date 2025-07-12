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
reg [15:0] sum0, sum1, sum2, sum3;
reg carry0, carry1, carry2, carry3;
reg en1, en2, en3;

// Intermediate signals
wire [16:0] sum0_w, sum1_w, sum2_w, sum3_w;

// Stage 1: Input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        en1 <= 1'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        en1 <= i_en;
    end
end

// Stage 2: First 16-bit chunk with carry=0
assign sum0_w = {1'b0, stage1_a[15:0]} + {1'b0, stage1_b[15:0]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0 <= 16'b0;
        carry0 <= 1'b0;
        en2 <= 1'b0;
    end else begin
        sum0 <= sum0_w[15:0];
        carry0 <= sum0_w[16];
        en2 <= en1;
    end
end

// Stage 3: Second 16-bit chunk with carry
assign sum1_w = {1'b0, stage1_a[31:16]} + {1'b0, stage1_b[31:16]} + carry0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 16'b0;
        carry1 <= 1'b0;
        en3 <= 1'b0;
    end else begin
        sum1 <= sum1_w[15:0];
        carry1 <= sum1_w[16];
        en3 <= en2;
    end
end

// Stage 4: Third 16-bit chunk with carry
assign sum2_w = {1'b0, stage1_a[47:32]} + {1'b0, stage1_b[47:32]} + carry1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 16'b0;
        carry2 <= 1'b0;
    end else begin
        sum2 <= sum2_w[15:0];
        carry2 <= sum2_w[16];
    end
end

// Stage 5: Final 16-bit chunk with carry and result assembly
assign sum3_w = {1'b0, stage1_a[63:48]} + {1'b0, stage1_b[63:48]} + carry2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum3 <= 16'b0;
        carry3 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        sum3 <= sum3_w[15:0];
        carry3 <= sum3_w[16];
        
        // Final result assembly
        result <= {carry3, sum3, sum2, sum1, sum0};
        o_en <= en3;
    end
end

endmodule