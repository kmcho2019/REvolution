module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

    // Register input data when data_en is high in clk_a domain
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'b0;
        else if (data_en)
            data_reg <= data_in;
    end

    // Two-stage synchronization of data_en in clk_b domain
    reg en_clap_one, en_clap_two;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= data_en;
            en_clap_two <= en_clap_one;
        end
    end

    // Update output data when synchronized enable is high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0;
        else if (en_clap_two)
            dataout <= data_reg;
        // else retain previous output
    end

endmodule