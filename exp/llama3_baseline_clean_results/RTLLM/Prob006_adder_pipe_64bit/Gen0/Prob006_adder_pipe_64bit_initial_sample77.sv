module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Input registers to store operands and input enable signal
reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg reg_i_en;

// Output registers to store result and output enable signal
reg [64:0] reg_result;
reg reg_o_en;

// Internal signals for ripple carry adder
reg [63:0] sum;
reg [63:0] carry;

// Pipeline stage 1: Store input operands and enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= i_en;
    end
end

// Pipeline stage 2: Perform ripple carry addition
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 64'd0;
        carry <= 64'd0;
    end else if (reg_i_en) begin
        reg [63:0] temp_sum;
        reg [63:0] temp_carry;
        temp_sum = reg_adda + reg_addb;
        temp_carry = (reg_adda & reg_addb) | (reg_adda & {64{1'b0}}) | (reg_addb & {64{1'b0}});
        sum <= temp_sum;
        carry <= temp_carry;
    end
end

// Pipeline stage 3: Update result and output enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_result <= 65'd0;
        reg_o_en <= 1'b0;
    end else if (reg_i_en) begin
        reg_result <= {1'b0, sum} + carry;
        reg_o_en <= 1'b1;
    end else begin
        reg_result <= reg_result;
        reg_o_en <= 1'b0;
    end
end

// Assign output signals
assign result = reg_result;
assign o_en = reg_o_en;

endmodule