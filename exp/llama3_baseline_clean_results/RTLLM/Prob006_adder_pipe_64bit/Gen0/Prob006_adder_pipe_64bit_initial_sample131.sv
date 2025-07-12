module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input  [63:0]   adda,
    input  [63:0]   addb,
    output [64:0]   result,
    output          o_en
);

// Internal signals
reg [63:0]         adda_reg1, adda_reg2;
reg [63:0]         addb_reg1, addb_reg2;
reg                i_en_reg1, i_en_reg2;
reg [64:0]         sum_reg;

// Stage 1: Input Registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
    end else if (i_en) begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
    end
end

// Stage 2: Ripple Carry Adder
wire [63:0] sum;
wire [63:0] carry;
assign sum[0] = adda_reg1[0] ^ addb_reg1[0];
assign carry[0] = adda_reg1[0] & addb_reg1[0];
for (genvar i = 1; i < 64; i++) begin
    assign sum[i] = adda_reg1[i] ^ addb_reg1[i] ^ carry[i-1];
    assign carry[i] = (adda_reg1[i] & addb_reg1[i]) | (adda_reg1[i] & carry[i-1]) | (addb_reg1[i] & carry[i-1]);
end

// Stage 3: Pipeline Registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'b0;
        sum_reg <= 65'd0;
    end else begin
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
        sum_reg <= {1'b0, sum} + {64'd0, carry[63]};
    end
end

// Stage 4: Output Logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en <= 1'b0;
        result <= 65'd0;
    end else if (i_en_reg2) begin
        o_en <= 1'b1;
        result <= sum_reg;
    end else begin
        o_en <= 1'b0;
        result <= 65'd0;
    end
end

endmodule