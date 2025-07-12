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
reg [3:0] prev_data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        prev_data_reg <= 4'd0;
    end else begin
        data_reg <= data_in;
        prev_data_reg <= data_reg;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 2'd0;
        dataout <= 4'd0;
    end else begin
        en_delay <= {en_delay[0], data_en};
        if (en_delay[1] && (data_reg != prev_data_reg)) begin
            dataout <= data_reg;
        end
    end
end

endmodule