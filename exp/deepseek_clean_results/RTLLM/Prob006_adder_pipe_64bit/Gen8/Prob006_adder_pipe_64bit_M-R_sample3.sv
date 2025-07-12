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
reg [31:0] stage1_lower_sum;
reg stage1_lower_carry;
reg stage1_valid;

// Lower 32-bit adder (combinational)
wire [31:0] lower_sum = adda[31:0] + addb[31:0];
wire lower_carry = (adda[31:0] + addb[31:0]) >> 32;

// Upper 32-bit adder (combinational, uses carry from lower bits)
wire [32:0] upper_sum = {1'b0, adda[63:32]} + {1'b0, addb[63:32]} + lower_carry;

// Pipeline stage 1 (register inputs and lower sum)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        stage1_lower_sum <= 32'b0;
        stage1_lower_carry <= 1'b0;
        stage1_valid <= 1'b0;
    end else begin
        if (i_en) begin
            stage1_a <= adda;
            stage1_b <= addb;
            stage1_lower_sum <= lower_sum;
            stage1_lower_carry <= lower_carry;
        end
        stage1_valid <= i_en;
    end
end

// Pipeline stage 2 (register final result)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (stage1_valid) begin
            result <= {upper_sum[32], upper_sum[31:0], stage1_lower_sum};
        end
        o_en <= stage1_valid;
    end
end

endmodule