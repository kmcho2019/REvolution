module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] stage1_sum;
reg [63:0] stage1_cout;
reg [64:0] final_sum;
reg o_en_reg;
reg i_en_reg;
reg i_en_reg2;

// Initialize result and o_en with default values
assign result = final_sum;
assign o_en = o_en_reg;

// Combinational logic for full adder chain
wire [63:0] stage1_cin;
assign stage1_cin = {64{1'b0}};

// First stage addition
genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin
        full_adder fa(
          .a(adda[i]),
          .b(addb[i]),
          .cin(i == 0? 1'b0 : stage1_cin[i-1]),
          .sum(stage1_sum[i]),
          .cout(stage1_cout[i])
        );
    end
endgenerate

// Final stage addition
assign final_sum = {1'b0, stage1_sum} + {64{stage1_cout[63]}};

// Pipeline stage management
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_sum <= 64'd0;
        stage1_cout <= 64'd0;
        final_sum <= 65'd0;
        i_en_reg <= 1'b0;
        i_en_reg2 <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
        i_en_reg2 <= i_en_reg;
        if (i_en_reg2) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

endmodule