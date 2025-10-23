module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Registers in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// Two-stage enable synchronization registers in clk_b domain with async reset
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

// Update output data on clk_b domain with async reset and mux selection
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'b0;
    else if (en_clap_two)
        dataout <= data_reg;
    else
        dataout <= dataout;  // hold previous value
end

endmodule