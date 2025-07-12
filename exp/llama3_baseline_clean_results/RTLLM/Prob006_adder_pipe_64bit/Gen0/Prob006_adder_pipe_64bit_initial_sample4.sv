module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg reg_i_en;
reg [63:0] sum;
reg [63:0] carry;
reg [63:0] reg_sum;
reg [63:0] reg_carry;
reg reg_o_en;

// Stage 1: Register input operands and input enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'd0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= i_en;
    end else begin
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
        reg_i_en <= reg_i_en;
    end
end

// Stage 2: Perform addition and generate sum and carry signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 64'd0;
        carry <= 64'd0;
    end else if (reg_i_en) begin
        {carry[0], sum[0]} = reg_adda[0] + reg_addb[0];
        for (int i = 1; i < 64; i++) begin
            {carry[i], sum[i]} = reg_adda[i] + reg_addb[i] + carry[i-1];
        end
    end else begin
        sum <= sum;
        carry <= carry;
    end
end

// Stage 3: Register sum and carry signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_sum <= 64'd0;
        reg_carry <= 64'd0;
    end else begin
        reg_sum <= sum;
        reg_carry <= carry;
    end
end

// Stage 4: Generate final output result and update output enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'd0;
    end else begin
        result <= {reg_carry[63], reg_sum};
        o_en <= reg_i_en;
    end
end

endmodule