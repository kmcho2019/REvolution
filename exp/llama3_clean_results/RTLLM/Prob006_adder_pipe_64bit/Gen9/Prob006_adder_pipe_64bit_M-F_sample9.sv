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

// Registers for input operands
reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;

// Register for output enable signal
reg o_en_reg;

// Output result register
reg [DATA_WIDTH:0] result_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        o_en_reg <= 1'b0;
    end
end

// Pipeline stage for addition
wire [DATA_WIDTH:0] sum;
assign sum = {1'b0, adda_reg} + {1'b0, addb_reg};

// Output registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
    end else begin
        result_reg <= sum;
        if (i_en) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule