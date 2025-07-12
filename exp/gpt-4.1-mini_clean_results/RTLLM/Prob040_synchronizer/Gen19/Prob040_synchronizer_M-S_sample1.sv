module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

reg [3:0] data_reg;
reg       en_clap_one, en_clap_two;

// Capture data_in on clk_a domain with async reset
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        data_reg <= 4'b0;
    else if (data_en) // Only update when data_en is high
        data_reg <= data_in;
end

// Synchronize data_en to clk_b domain through two flip-flops
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= data_en;
        en_clap_two <= en_clap_one;
    end
end

// Update output dataout in clk_b domain when synchronized enable is active
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'b0;
    else if (en_clap_two)
        dataout <= data_reg;
end

endmodule