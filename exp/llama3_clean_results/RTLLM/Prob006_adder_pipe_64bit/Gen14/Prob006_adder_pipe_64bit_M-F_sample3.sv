// Define a full adder module
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the 64-bit ripple carry adder module
module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] adda_reg1;
reg [63:0] addb_reg1;
reg [63:0] adda_reg2;
reg [63:0] addb_reg2;
reg        i_en_reg1;
reg        i_en_reg2;
reg [64:0] sum_reg;

// Pipeline stage management
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'b0;
        sum_reg <= 65'd0;
        o_en <= 1'b0;
    end else begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
        if (i_en_reg2) begin
            sum_reg <= {1'b0, adda_reg2} + {1'b0, addb_reg2};
        end
        o_en <= i_en_reg2;
    end
end

// Assign result
assign result = sum_reg;

endmodule