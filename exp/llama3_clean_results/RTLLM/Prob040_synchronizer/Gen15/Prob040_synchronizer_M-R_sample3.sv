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
reg en_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else begin
        data_reg <= data_in;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_reg <= 1'b0;
        dataout <= 4'd0;
    end else begin
        en_reg <= data_en;
        if (en_reg) begin
            dataout <= data_reg;
        end
    end
end

endmodule