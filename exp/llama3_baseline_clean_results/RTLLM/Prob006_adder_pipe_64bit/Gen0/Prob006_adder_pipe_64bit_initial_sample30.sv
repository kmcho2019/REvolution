module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] pipe_adda;
reg [63:0] pipe_addb;
reg pipe_i_en;
reg [63:0] sum;
reg [63:0] carry;
reg [64:0] final_sum;
reg o_en_pipe;

// Stage 1: Register input operands and enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_adda <= 64'd0;
        pipe_addb <= 64'd0;
        pipe_i_en <= 1'b0;
    end else if (i_en) begin
        pipe_adda <= adda;
        pipe_addb <= addb;
        pipe_i_en <= 1'b1;
    end
end

// Stage 2: Calculate sum and carry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 64'd0;
        carry <= 64'd0;
    end else if (pipe_i_en) begin
        sum <= pipe_adda + pipe_addb;
        carry <= (pipe_adda + pipe_addb) >> 64;
    end
end

// Stage 3: Update final sum and output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_sum <= 65'd0;
        o_en_pipe <= 1'b0;
    end else if (pipe_i_en) begin
        final_sum <= {carry[0], sum};
        o_en_pipe <= 1'b1;
    end else begin
        o_en_pipe <= 1'b0;
    end
end

// Output assignments
assign result = final_sum;
assign o_en = o_en_pipe;

endmodule