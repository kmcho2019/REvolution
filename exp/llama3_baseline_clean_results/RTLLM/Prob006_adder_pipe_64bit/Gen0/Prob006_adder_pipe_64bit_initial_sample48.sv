module adder_pipe_64bit(
    input               clk,       // Clock input
    input               rst_n,     // Active low reset signal
    input               i_en,      // Enable signal for addition operation
    input   [63:0]      adda,      // 64-bit input operand A
    input   [63:0]      addb,      // 64-bit input operand B
    output  [64:0]      result,   // 65-bit output representing the sum of adda and addb
    output              o_en       // Output enable signal
);

reg [63:0]              stage1_a;
reg [63:0]              stage1_b;
reg [63:0]              stage2_sum;
reg                     stage2_cout;
reg [64:0]              stage3_result;
reg                     stage3_o_en;

// Input stage registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
    end
end

// First pipeline stage: Input operands
reg                     stage1_o_en;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_o_en <= 1'b0;
    end else begin
        stage1_o_en <= i_en;
    end
end

// Second pipeline stage: Ripple carry adder
wire [63:0]             sum;
wire [63:0]             carry;
assign sum[0] = stage1_a[0] ^ stage1_b[0];
assign carry[0] = stage1_a[0] & stage1_b[0];
for (genvar i = 1; i < 64; i++) begin
    assign sum[i] = stage1_a[i] ^ stage1_b[i] ^ carry[i-1];
    assign carry[i] = (stage1_a[i] & stage1_b[i]) | (stage1_a[i] & carry[i-1]) | (stage1_b[i] & carry[i-1]);
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 64'd0;
        stage2_cout <= 1'b0;
    end else if (stage1_o_en) begin
        stage2_sum <= sum;
        stage2_cout <= carry[63];
    end
end

// Third pipeline stage: Output result and enable
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_result <= 65'd0;
        stage3_o_en <= 1'b0;
    end else if (stage1_o_en) begin
        stage3_result <= {stage2_cout, stage2_sum};
        stage3_o_en <= stage1_o_en;
    end
end

assign result = stage3_result;
assign o_en = stage3_o_en;

endmodule