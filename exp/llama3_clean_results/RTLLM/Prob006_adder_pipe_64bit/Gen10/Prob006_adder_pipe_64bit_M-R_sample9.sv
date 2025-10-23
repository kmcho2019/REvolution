module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] sum_reg;
reg [63:0] carry_reg;
reg [64:0] final_sum_reg;
reg [1:0]  i_en_reg;

assign result = final_sum_reg;

// Combinational logic for sum and carry
wire [63:0] sum;
wire [63:0] carry;
assign sum = adda ^ addb;
assign carry = (adda & addb) | (adda & {64{1'b0}}) | (addb & {64{1'b0}});

// Pipeline stage management
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 64'd0;
        carry_reg <= 64'd0;
        final_sum_reg <= 65'd0;
        i_en_reg <= 2'b00;
        o_en <= 1'b0;
    end else begin
        i_en_reg <= {i_en_reg[0], i_en};
        if (i_en_reg[1]) begin
            sum_reg <= sum;
            carry_reg <= carry;
            final_sum_reg <= {1'b0, sum_reg} + {64{carry_reg[63]}};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule