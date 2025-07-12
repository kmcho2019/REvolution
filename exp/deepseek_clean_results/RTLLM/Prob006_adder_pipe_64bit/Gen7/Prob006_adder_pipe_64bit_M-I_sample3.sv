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
reg [15:0] sum0;
reg carry0;
reg [31:0] sum1;
reg carry1;
reg [2:0] en_pipe;

// Intermediate signals
wire [16:0] sum0_w;
wire [17:0] sum1_w;
wire [33:0] sum2_w;

// Stage 1: Input registration and first 16-bit addition
assign sum0_w = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        sum0 <= 16'b0;
        carry0 <= 1'b0;
        en_pipe <= 3'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        sum0 <= sum0_w[15:0];
        carry0 <= sum0_w[16];
        en_pipe <= {en_pipe[1:0], i_en};
    end
end

// Stage 2: Next 16 bits with carry from stage1
assign sum1_w = {1'b0, stage1_a[31:16]} + {1'b0, stage1_b[31:16]} + carry0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 32'b0;
        carry1 <= 1'b0;
    end else begin
        sum1[15:0] <= sum1_w[15:0];
        carry1 <= sum1_w[16];
        sum1[31:16] <= stage1_a[31:16];  // Save upper bits for final assembly
    end
end

// Stage 3: Final 32 bits with carry and result assembly
assign sum2_w = {1'b0, stage1_a[63:32]} + {1'b0, stage1_b[63:32]} + carry1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {sum2_w[32:0], sum1[15:0], sum0};
        o_en <= en_pipe[2];
    end
end

endmodule