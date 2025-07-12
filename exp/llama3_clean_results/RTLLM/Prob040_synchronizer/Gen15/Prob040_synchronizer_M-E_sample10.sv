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
reg [1:0] counter;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        counter <= 2'd0;
    end else if (data_en) begin
        data_reg <= data_in;
        counter <= counter + 1;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (counter > 2'd2) begin
        dataout <= data_reg;
        counter <= counter - 1;
    end
end

endmodule