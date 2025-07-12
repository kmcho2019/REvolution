module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output wire o_en
);

// Pipeline stage registers
reg [63:0] stage1_a, stage1_b;
reg stage1_en;
reg [64:0] stage2_result;
reg stage2_en;

// Combinational logic
wire [64:0] sum = {1'b0, stage1_a} + {1'b0, stage1_b};

// Output assignments
assign result = stage2_result;
assign o_en = stage2_en;

// Pipeline stage 1: Input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        stage1_en <= 1'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        stage1_en <= i_en;
    end
end

// Pipeline stage 2: Result registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_result <= 65'b0;
        stage2_en <= 1'b0;
    end else begin
        stage2_result <= sum;
        stage2_en <= stage1_en;
    end
end

endmodule