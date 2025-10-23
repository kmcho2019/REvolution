module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 2
)(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result,
    output o_en
);

reg [DATA_WIDTH-1:0] adda_reg1, adda_reg2, addb_reg1, addb_reg2;
reg [DATA_WIDTH:0] sum_reg1, sum_reg2;
reg i_en_reg1, i_en_reg2, o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= {DATA_WIDTH{1'b0}};
        addb_reg1 <= {DATA_WIDTH{1'b0}};
        i_en_reg1 <= 1'b0;
        adda_reg2 <= {DATA_WIDTH{1'b0}};
        addb_reg2 <= {DATA_WIDTH{1'b0}};
        sum_reg1 <= {DATA_WIDTH+1{1'b0}};
        sum_reg2 <= {DATA_WIDTH+1{1'b0}};
        i_en_reg2 <= 1'b0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg2 <= {DATA_WIDTH{1'b0}};
        addb_reg2 <= {DATA_WIDTH{1'b0}};
        i_en_reg2 <= 1'b0;
        sum_reg1 <= {DATA_WIDTH+1{1'b0}};
    end else begin
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
        sum_reg1 <= {1'b0} + adda_reg1 + addb_reg1; // Properly handle the carry signal
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg2 <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en_reg2) begin
        sum_reg2 <= sum_reg1;
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = sum_reg2;
assign o_en = o_en_reg;

endmodule