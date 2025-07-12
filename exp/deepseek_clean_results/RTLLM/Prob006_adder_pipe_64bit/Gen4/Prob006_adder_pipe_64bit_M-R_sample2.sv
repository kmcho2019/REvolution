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
reg stage1_en;

// Combinational adder signals
wire [63:0] sum;
wire carry_out;

// Ripple carry adder implementation using continuous assignment
assign {carry_out, sum} = stage1_a + stage1_b + {63'b0, stage1_en}; // stage1_en acts as cin

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
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {carry_out, sum};
        o_en <= stage1_en;
    end
end

endmodule