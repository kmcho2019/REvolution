module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Internal signals
reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [63:0] sum;
reg [63:0] carry;
reg i_en_reg;
reg i_en_pipe1;
reg i_en_pipe2;
reg [64:0] result_reg;

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= 1'b1;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
        i_en_reg <= 1'b0;
    end
end

// Pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i_en_pipe1 <= 1'b0;
        i_en_pipe2 <= 1'b0;
    end else begin
        i_en_pipe1 <= i_en_reg;
        i_en_pipe2 <= i_en_pipe1;
    end
end

// Ripple carry adder
always @(*) begin
    {carry, sum} = adda_reg + addb_reg;
end

// Output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_reg <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_pipe2) begin
        result_reg <= {carry[63], sum};
        o_en <= 1'b1;
    end else begin
        result_reg <= result_reg;
        o_en <= 1'b0;
    end
end

assign result = result_reg;

endmodule