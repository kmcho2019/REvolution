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
reg en_data_reg;
reg [1:0] en_delay;
reg [3:0] dataout_reg;

assign dataout = dataout_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'd0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 2'd0;
        dataout_reg <= 4'd0;
    end else begin
        if (en_data_reg) begin
            en_delay <= en_delay + 1'd1;
        end else begin
            en_delay <= 2'd0;
        end
        if (en_delay == 2'd2) begin
            dataout_reg <= data_reg;
        end
    end
end

endmodule