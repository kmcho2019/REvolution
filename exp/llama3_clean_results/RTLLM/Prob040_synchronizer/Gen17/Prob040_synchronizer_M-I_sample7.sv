module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [1:0] en_clap;
reg [3:0] data_reg;

always @(posedge clk_a) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_clap[0] <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        en_clap[0] <= 1'b1;
    end else begin
        en_clap[0] <= 1'b0;
    end
end

always @(posedge clk_b) begin
    if (!brstn) begin
        en_clap[1] <= 1'b0;
        dataout <= 4'd0;
    end else begin
        en_clap[1] <= en_clap[0];
        if (en_clap[1]) begin
            dataout <= data_reg;
        end
    end
end

endmodule