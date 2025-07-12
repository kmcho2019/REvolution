module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg en_clap_one;
reg en_clap_two;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_clap_one <= 1'b0;
    end else if (data_en) begin
        en_clap_one <= 1'b1;
    end else begin
        en_clap_one <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_two <= 1'b0;
        dataout <= 4'd0;
    end else begin
        if(en_clap_one) begin
            en_clap_two <= 1'b1;
        end else if (!en_clap_one && en_clap_two) begin
            en_clap_two <= 1'b1;
        end else begin
            en_clap_two <= 1'b0;
        end
        if (en_clap_two) begin
            dataout <= data_in;
        end
    end
end

endmodule