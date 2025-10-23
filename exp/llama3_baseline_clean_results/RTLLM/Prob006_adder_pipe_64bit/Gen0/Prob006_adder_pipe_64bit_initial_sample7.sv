module adder_pipe_64bit (
    input        clk,
    input        rst_n,
    input        i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output [64:0] result,
    output       o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [64:0] sum;
reg        i_en_reg;
reg        o_en_reg;
reg [63:0] carry;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg    <= 64'd0;
        addb_reg    <= 64'd0;
        sum        <= 65'd0;
        i_en_reg   <= 1'b0;
        o_en_reg   <= 1'b0;
    end else if (i_en) begin
        adda_reg    <= adda;
        addb_reg    <= addb;
        i_en_reg   <= i_en;
    end else begin
        adda_reg    <= adda_reg;
        addb_reg    <= addb_reg;
        i_en_reg   <= i_en_reg;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg   <= 1'b0;
        sum        <= 65'd0;
    end else if (i_en_reg) begin
        sum        <= adda_reg + addb_reg;
        o_en_reg   <= 1'b1;
    end else begin
        sum        <= sum;
        o_en_reg   <= (o_en_reg == 1'b1) ? 1'b0 : o_en_reg;
    end
end

assign result = sum;
assign o_en   = o_en_reg;

endmodule