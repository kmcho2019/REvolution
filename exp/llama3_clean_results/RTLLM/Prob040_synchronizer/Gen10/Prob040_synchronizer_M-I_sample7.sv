module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg [1:0] en_delay;
reg clk_a_en, clk_b_en;

// Clock enable signals for power optimization
assign clk_a_en = data_en || (data_reg!= data_in);
assign clk_b_en = en_delay[1] || (en_delay[0]!= data_en);

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (clk_a_en) begin
        if (data_en) begin
            data_reg <= data_in;
        end
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 2'd0;
        dataout <= 4'd0;
    end else if (clk_b_en) begin
        en_delay <= {en_delay[0], data_en};
        if (en_delay[1]) begin
            dataout <= data_reg;
        end
    end
end

endmodule