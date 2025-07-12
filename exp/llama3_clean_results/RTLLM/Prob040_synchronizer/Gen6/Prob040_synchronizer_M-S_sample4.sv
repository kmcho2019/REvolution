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
reg en_delay;
reg en_delay_prev;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else begin
        data_reg <= data_in;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 1'b0;
        en_delay_prev <= 1'b0;
        dataout <= 4'd0;
    end else begin
        en_delay_prev <= en_delay;
        en_delay <= data_en;
        if (en_delay && en_delay_prev) begin
            dataout <= data_reg;
        end
    end
end

endmodule