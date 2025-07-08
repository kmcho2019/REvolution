module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,     // active low reset for clk_a domain
    input             brstn,     // active low reset for clk_b domain
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Data register and enable data register in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg     <= 4'b0;
        en_data_reg  <= 1'b0;
    end else begin
        data_reg     <= data_in;
        en_data_reg  <= data_en;
    end
end

// Enable control registers synchronized to clk_b domain
reg en_clap_one;
reg en_clap_two;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output data register updated in clk_b domain
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end else begin
        dataout <= dataout;
    end
end

endmodule