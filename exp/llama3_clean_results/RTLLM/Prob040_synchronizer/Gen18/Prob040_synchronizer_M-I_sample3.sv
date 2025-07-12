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
reg [3:0] data_reg_sync1;
reg [3:0] data_reg_sync2;
reg data_en_reg;
reg data_en_reg_sync1;
reg data_en_reg_sync2;

// Clock Domain Crossing (CDC) module
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        data_en_reg <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        data_en_reg <= 1'b1;
    end
end

// Data synchronizer module
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_reg_sync1 <= 4'd0;
        data_reg_sync2 <= 4'd0;
        data_en_reg_sync1 <= 1'b0;
        data_en_reg_sync2 <= 1'b0;
        dataout <= 4'd0;
    end else begin
        data_reg_sync1 <= data_reg;
        data_reg_sync2 <= data_reg_sync1;
        data_en_reg_sync1 <= data_en_reg;
        data_en_reg_sync2 <= data_en_reg_sync1;
        if (data_en_reg_sync2) begin
            dataout <= data_reg_sync2;
        end
    end
end

endmodule