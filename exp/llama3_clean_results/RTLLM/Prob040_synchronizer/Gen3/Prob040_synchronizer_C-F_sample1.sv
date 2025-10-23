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
reg en_clap_one;
reg en_clap_two;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else begin
        data_reg <= data_in;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'd0;
        en_clap_two <= 1'd0;
        dataout <= 4'd0;
    end else begin
        en_clap_one <= data_en;
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            dataout <= data_reg;
        end else begin
            // To prevent dataout from being 'x', assign previous value when not updating
            dataout <= dataout;
        end
    end
end

endmodule