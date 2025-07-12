module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output [3:0] dataout
);

reg [3:0] data_capture;
reg [3:0] data_transfer;
reg [3:0] dataout_reg;

always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_capture <= 4'd0;
    end else begin
        data_capture <= data_in;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        data_transfer <= 4'd0;
        dataout_reg <= 4'd0;
    end else begin
        data_transfer <= data_capture;
        if (data_en) begin
            dataout_reg <= data_transfer;
        end
    end
end

assign dataout = dataout_reg;

endmodule