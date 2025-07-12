module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;
reg i_en_reg2;
reg [64:0] result_reg;
reg o_en_reg;

// Input stage
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= 1'b1;
    end
end

// Second stage to synchronize i_en
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg2 <= 1'b0;
    end else begin
        i_en_reg2 <= i_en_reg;
    end
end

// Addition stage
wire [63:0] sum;
wire cout;
assign {cout, sum} = adda_reg + addb_reg;

// Output stage
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en_reg2) begin
        result_reg <= {cout, sum};
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule