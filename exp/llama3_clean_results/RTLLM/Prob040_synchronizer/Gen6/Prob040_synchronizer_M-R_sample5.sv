module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg [1:0] en_delay;

assign data_reg = arstn ? data_in : 4'd0;

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_delay <= 2'd0;
        dataout <= 4'd0;
    end else begin
        en_delay <= {en_delay[0], data_en};
        if (en_delay[1]) begin
            dataout <= data_reg;
        end
    end
end

endmodule