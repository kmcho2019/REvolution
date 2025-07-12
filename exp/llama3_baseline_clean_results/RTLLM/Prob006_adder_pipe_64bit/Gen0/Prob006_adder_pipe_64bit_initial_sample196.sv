module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Internal signals
reg [63:0] adda_pipe;
reg [63:0] addb_pipe;
reg i_en_pipe;
reg [63:0] sum;
reg [63:0] carry;

// Pipeline stage 1: Register the input enable signal and input operands
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe <= 64'd0;
        addb_pipe <= 64'd0;
        i_en_pipe <= 1'd0;
    end else if (i_en) begin
        adda_pipe <= adda;
        addb_pipe <= addb;
        i_en_pipe <= 1'd1;
    end else begin
        adda_pipe <= adda_pipe;
        addb_pipe <= addb_pipe;
        i_en_pipe <= i_en_pipe;
    end
end

// Ripple carry adder
always @(*) begin
    carry[0] = 1'd0;
    for (int i = 0; i < 64; i++) begin
        sum[i] = adda_pipe[i] ^ addb_pipe[i] ^ carry[i];
        carry[i+1] = (adda_pipe[i] & addb_pipe[i]) | (adda_pipe[i] & carry[i]) | (addb_pipe[i] & carry[i]);
    end
    result[63:0] = sum;
    result[64] = carry[63];
end

// Pipeline stage 2: Register the output result and update the output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 1'd0;
    end else if (i_en_pipe) begin
        o_en <= 1'd1;
    end else begin
        o_en <= 1'd0;
    end
end

endmodule