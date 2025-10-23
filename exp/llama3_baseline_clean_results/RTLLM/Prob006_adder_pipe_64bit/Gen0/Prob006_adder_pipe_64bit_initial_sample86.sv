module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Internal signals
reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg reg_i_en;
reg [63:0] sum;
reg [63:0] carry;
reg [64:0] reg_result;
reg reg_o_en;

// Stage 1: Input stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= 1'b1;
    end else begin
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
        reg_i_en <= reg_i_en;
    end
end

// Stage 2: Addition stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 64'd0;
        carry <= 64'd0;
    end else if (reg_i_en) begin
        {carry, sum} <= reg_adda + reg_addb;
    end else begin
        sum <= sum;
        carry <= carry;
    end
end

// Stage 3: Output stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_result <= 65'd0;
        reg_o_en <= 1'b0;
    end else if (reg_i_en) begin
        reg_result <= {1'b0, sum} + {64'd0, carry[63]};
        reg_o_en <= 1'b1;
    end else begin
        reg_result <= reg_result;
        if (reg_o_en) begin
            reg_o_en <= 1'b0;
        end else begin
            reg_o_en <= reg_o_en;
        end
    end
end

// Output assignments
assign result = reg_result;
assign o_en = reg_o_en;

endmodule