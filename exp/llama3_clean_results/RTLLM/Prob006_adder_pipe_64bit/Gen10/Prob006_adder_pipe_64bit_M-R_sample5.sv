module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [DATA_WIDTH:0] result_reg;
reg o_en_reg;

// Continuous assignment for sum calculation
wire [DATA_WIDTH:0] sum;
assign sum = {1'b0, adda_reg} + {1'b0, addb_reg};

// Single always block for all sequential logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        result_reg <= sum;
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Continuous assignments for outputs
assign result = result_reg;
assign o_en = o_en_reg;

endmodule