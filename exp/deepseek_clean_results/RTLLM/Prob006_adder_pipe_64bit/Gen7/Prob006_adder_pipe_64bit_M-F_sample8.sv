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
reg [63:0] a_reg, b_reg;
reg [31:0] lower_sum;
reg lower_carry;
reg stage1_valid;

// First stage: Compute lower 32 bits
wire [32:0] lower_sum_full = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};

// Second stage: Compute upper 32 bits with carry from first stage
wire [32:0] upper_sum_full = {1'b0, a_reg[63:32]} + {1'b0, b_reg[63:32]} + lower_carry;

// Pipeline stage 1: Register inputs and compute lower 32 bits
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        lower_sum <= 32'b0;
        lower_carry <= 1'b0;
        stage1_valid <= 1'b0;
    end else if (i_en) begin
        a_reg <= adda;
        b_reg <= addb;
        lower_sum <= lower_sum_full[31:0];
        lower_carry <= lower_sum_full[32];
        stage1_valid <= 1'b1;
    end else begin
        stage1_valid <= 1'b0;
    end
end

// Pipeline stage 2: Compute upper bits and final result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (stage1_valid) begin
            result <= {upper_sum_full[32], upper_sum_full[31:0], lower_sum};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule