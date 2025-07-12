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
reg [1:0] en_data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 2'd0;
    end else if (data_en) begin
        data_reg <= data_in;
        en_data_reg <= en_data_reg + 1'd1;
    end else begin
        en_data_reg <= 2'd0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_data_reg[1]) begin
        dataout <= data_reg;
    end 
end

endmodule