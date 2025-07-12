module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [31:0] a_low, a_high;
reg [31:0] b_low, b_high;
reg carry_low;
reg en_stage1, en_stage2;

// Combinational sums
wire [32:0] sum_low = {1'b0, a_low} + {1'b0, b_low};
wire [32:0] sum_high = {1'b0, a_high} + {1'b0, b_high} + {32'b0, carry_low};

// Final result assignment
assign result = {sum_high[32], sum_high[31:0], sum_low[31:0]};

// First stage pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_low <= 32'b0;
        b_low <= 32'b0;
        en_stage1 <= 1'b0;
    end else begin
        a_low <= adda[31:0];
        b_low <= addb[31:0];
        en_stage1 <= i_en;
    end
end

// Second stage pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_high <= 32'b0;
        b_high <= 32'b0;
        carry_low <= 1'b0;
        en_stage2 <= 1'b0;
        o_en <= 1'b0;
    end else begin
        a_high <= adda[63:32];
        b_high <= addb[63:32];
        carry_low <= sum_low[32];
        en_stage2 <= en_stage1;
        o_en <= en_stage2;
    end
end

endmodule