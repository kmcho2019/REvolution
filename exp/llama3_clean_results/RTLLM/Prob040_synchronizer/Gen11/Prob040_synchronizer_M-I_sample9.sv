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
reg en_clap_one;
reg en_clap_two;

// Synchronize data_en from clk_a domain to clk_b domain
reg [1:0] data_en_sync;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        en_data_reg <= 1'b1;
    end else begin
        en_data_reg <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
        dataout <= 4'd0;
        data_en_sync <= 2'b00;
    end else begin
        data_en_sync[0] <= en_data_reg;
        data_en_sync[1] <= data_en_sync[0];
        en_clap_one <= data_en_sync[1];
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            dataout <= data_reg;
        end
    end
end

endmodule