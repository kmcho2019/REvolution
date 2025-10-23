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
reg [1:0] gray_counter;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_delay <= 2'd0;
    end else if (data_en) begin
        data_reg <= data_in;
        en_delay <= {en_delay[0], 1'b1};
    end else begin
        en_delay <= 2'd0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        gray_counter <= 2'd0;
        dataout <= 4'd0;
    end else if (en_delay[1]) begin
        gray_counter <= gray_counter + 1'b1;
        dataout <= data_reg;
    end else begin
        dataout <= dataout;
    end
end

endmodule