module adder_pipe_64bit(
    input             clk,
    input             rst_n,
    input             i_en,
    input  [63:0]     adda,
    input  [63:0]     addb,
    output [64:0]     result,
    output            o_en
);

// Internal signals
reg [63:0]           adda_pipe;
reg [63:0]           addb_pipe;
reg [63:0]           sum_pipe;
reg                   carry_pipe;
reg                   i_en_pipe;
reg                   o_en_pipe;
wire [63:0]           sum;
wire [63:0]           carry;

// Pipeline stage 1: input operand and enable signal registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe <= 64'd0;
        addb_pipe <= 64'd0;
        i_en_pipe <= 1'b0;
    end else if (i_en) begin
        adda_pipe <= adda;
        addb_pipe <= addb;
        i_en_pipe <= 1'b1;
    end else begin
        adda_pipe <= adda_pipe;
        addb_pipe <= addb_pipe;
        i_en_pipe <= i_en_pipe;
    end
end

// 64-bit ripple carry adder
assign sum[0] = adda_pipe[0] ^ addb_pipe[0] ^ carry_pipe;
assign carry[0] = (adda_pipe[0] & addb_pipe[0]) | (adda_pipe[0] & carry_pipe) | (addb_pipe[0] & carry_pipe);

genvar i;
generate
    for (i = 1; i < 64; i++) begin
        assign sum[i] = adda_pipe[i] ^ addb_pipe[i] ^ carry[i-1];
        assign carry[i] = (adda_pipe[i] & addb_pipe[i]) | (adda_pipe[i] & carry[i-1]) | (addb_pipe[i] & carry[i-1]);
    end
endgenerate

assign result[63:0] = sum;
assign result[64] = carry[63];

// Pipeline stage 2: sum and carry registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_pipe <= 64'd0;
        carry_pipe <= 1'b0;
    end else if (i_en_pipe) begin
        sum_pipe <= sum;
        carry_pipe <= carry[63];
    end else begin
        sum_pipe <= sum_pipe;
        carry_pipe <= carry_pipe;
    end
end

// Pipeline stage 3: output enable signal register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_pipe <= 1'b0;
    end else if (i_en_pipe) begin
        o_en_pipe <= 1'b1;
    end else if (o_en_pipe) begin
        o_en_pipe <= 1'b0;
    end else begin
        o_en_pipe <= o_en_pipe;
    end
end

assign o_en = o_en_pipe;

endmodule