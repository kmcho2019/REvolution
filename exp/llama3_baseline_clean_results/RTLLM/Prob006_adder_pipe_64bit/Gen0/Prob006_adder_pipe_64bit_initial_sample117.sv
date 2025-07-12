module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] adda_pipe;
reg [63:0] addb_pipe;
reg i_en_pipe;
reg [63:0] sum;
reg [63:0] carry;

// Stage 1: Input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_pipe <= 64'd0;
        addb_pipe <= 64'd0;
        i_en_pipe <= 1'b0;
    end else if (i_en) begin
        adda_pipe <= adda;
        addb_pipe <= addb;
        i_en_pipe <= i_en;
    end
end

// Stage 2-65: Ripple carry adder stages
reg [64:0] carry_pipe;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        carry_pipe <= 1'b0;
    end else begin
        carry_pipe <= {1'b0, adda_pipe[0]} + {1'b0, addb_pipe[0]} + carry_pipe[0];
        for (int i = 1; i < 64; i++) begin
            carry_pipe[i] <= carry_pipe[i-1] + adda_pipe[i] + addb_pipe[i];
        end
    end
end

// Stage 66: Output register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_pipe) begin
        result <= carry_pipe;
        o_en <= i_en_pipe;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule