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
reg data_en_reg;
reg data_en_delay;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        data_en_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        data_en_reg <= data_en;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_en_delay <= 1'b0;
        dataout <= 4'd0;
    end else begin
        data_en_delay <= data_en_reg;
        if (data_en_delay) begin
            dataout <= data_reg;
        end
    end
end

endmodule