module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage 1 registers
reg [63:0] a_reg, b_reg;
reg en_reg;

// Pipeline stage 2 signals
wire [64:0] sum_with_carry;

// Continuous assignments for combinational logic
assign sum_with_carry = {1'b0, a_reg} + {1'b0, b_reg};

// Pipeline stage 1: Input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        en_reg <= 1'b0;
    end else begin
        a_reg <= adda;
        b_reg <= addb;
        en_reg <= i_en;
    end
end

// Pipeline stage 2: Result registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= sum_with_carry;
        o_en <= en_reg;
    end
end

endmodule