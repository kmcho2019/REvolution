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
reg [DATA_WIDTH:0] sum_reg1;
reg [DATA_WIDTH:0] sum_reg2;
reg [DATA_WIDTH:0] result_reg;
reg o_en_reg;
reg [1:0] stage_cnt;

// Continuous assignment for sum calculation
wire [DATA_WIDTH:0] sum;
assign sum = {1'b0, adda_reg} + {1'b0, addb_reg};

// Single always block for all sequential logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        sum_reg1 <= {DATA_WIDTH+1{1'b0}};
        sum_reg2 <= {DATA_WIDTH+1{1'b0}};
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
        stage_cnt <= 2'b00;
    end else begin
        if (i_en && stage_cnt == 2'b00) begin
            adda_reg <= adda;
            addb_reg <= addb;
            stage_cnt <= 2'b01;
        end else if (stage_cnt == 2'b01) begin
            sum_reg1 <= sum;
            stage_cnt <= 2'b10;
        end else if (stage_cnt == 2'b10) begin
            sum_reg2 <= sum_reg1;
            stage_cnt <= 2'b11;
        end else if (stage_cnt == 2'b11) begin
            result_reg <= sum_reg2;
            o_en_reg <= 1'b1;
            stage_cnt <= 2'b00;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

// Continuous assignments for outputs
assign result = result_reg;
assign o_en = o_en_reg;

endmodule