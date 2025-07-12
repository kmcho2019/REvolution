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
reg carry0, carry1;
reg en1, en2, en3;

// Carry-lookahead signals for upper 32 bits
wire [16:0] sum0_w, sum1_w;
wire [32:0] sum23_w;
wire carry1_w, carry2_w;

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

// Stage 2: First 16-bit chunk
assign sum0_w = stage1_a[15:0] + stage1_b[15:0];

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
assign sum1_w = stage1_a[31:16] + stage1_b[31:16] + carry0;

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

// Stage 4: Upper 32 bits with carry-lookahead
// Compute both possible sums for upper bits (with and without carry)
wire [32:0] sum23_c0 = stage1_a[63:32] + stage1_b[63:32];
wire [32:0] sum23_c1 = stage1_a[63:32] + stage1_b[63:32] + 1'b1;

// Select correct sum based on carry from lower bits
assign sum23_w = carry1 ? sum23_c1 : sum23_c0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 16'b0;
        sum3 <= 16'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        sum2 <= sum23_w[15:0];
        sum3 <= sum23_w[31:16];
        
        // Final result assembly
        if (en3) begin
            result <= {sum23_w[32], sum3, sum2, sum1, sum0};
        end else begin
            result <= 65'b0;
        end
        
        o_en <= en3;
    end
end

endmodule