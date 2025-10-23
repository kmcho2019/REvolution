module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [1:0] state;
reg [3:0] data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        state <= 2'b00;
        data_reg <= 4'd0;
    end else if (state == 2'b00 && data_en) begin
        state <= 2'b01;
        data_reg <= data_in;
    end else if (state == 2'b01 &&!data_en) begin
        state <= 2'b10;
    end else if (state == 2'b10 && data_en) begin
        state <= 2'b00;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (state == 2'b01) begin
        dataout <= data_reg;
    end
end

endmodule