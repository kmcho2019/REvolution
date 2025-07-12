module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg_a;
reg [3:0] data_reg_b;
reg en_clap_one;
reg en_clap_two;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg_a <= 4'd0;
        en_clap_one <= 1'b0;
    end else if (data_en) begin
        data_reg_a <= data_in;
        en_clap_one <= 1'b1;
    end else begin
        en_clap_one <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_reg_b <= 4'd0;
        en_clap_two <= 1'b0;
        dataout <= 4'd0;
    end else begin
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            data_reg_b <= data_reg_a;
            dataout <= data_reg_b;
        end
    end
end

endmodule