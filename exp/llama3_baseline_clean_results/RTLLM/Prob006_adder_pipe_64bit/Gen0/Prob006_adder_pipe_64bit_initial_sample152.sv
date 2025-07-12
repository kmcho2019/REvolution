module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Pipeline stage 1: Input registers
reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'd0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
        i_en_reg <= i_en_reg;
    end
end

// Pipeline stage 2: Ripple carry adder
wire [63:0] sum;
wire [63:0] carry;

assign sum[0] = adda_reg[0] ^ addb_reg[0];
assign carry[0] = adda_reg[0] & addb_reg[0];

genvar i;
generate
    for (i = 1; i < 64; i++) begin
        assign sum[i] = adda_reg[i] ^ addb_reg[i] ^ carry[i-1];
        assign carry[i] = (adda_reg[i] & addb_reg[i]) | (adda_reg[i] & carry[i-1]) | (addb_reg[i] & carry[i-1]);
    end
endgenerate

// Pipeline stage 3: Output registers
reg [64:0] result_reg;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'd0;
    end else if (i_en_reg) begin
        result_reg <= {1'd0, sum} + {64'd0, carry[63]};
        o_en_reg <= 1'd1;
    end else begin
        result_reg <= result_reg;
        o_en_reg <= o_en_reg;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule