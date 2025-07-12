module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,      // async active low reset clk_a domain
    input             brstn,      // async active low reset clk_b domain
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Data and enable register in clk_a domain (with async reset)
reg [3:0] data_reg;
reg       en_data_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        // Only latch data and enable when data_en is high (stable period)
        if (data_en) begin
            data_reg    <= data_in;
            en_data_reg <= 1'b1;
        end else begin
            en_data_reg <= 1'b0;
        end
    end
end

// Two-stage enable synchronizer in clk_b domain (with async reset)
reg en_clap_one, en_clap_two;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// MUX-based output register update on clk_b domain
// If en_clap_two is asserted, update dataout with data_reg (latched in clk_a domain)
// Otherwise hold previous value
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else begin
        dataout <= en_clap_two ? data_reg : dataout;
    end
end

endmodule