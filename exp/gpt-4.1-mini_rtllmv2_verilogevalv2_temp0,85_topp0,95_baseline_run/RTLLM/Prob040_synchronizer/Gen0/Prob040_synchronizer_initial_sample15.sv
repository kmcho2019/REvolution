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

    // Registers in clk_b domain
    reg en_clap_one;
    reg en_clap_two;

    // clk_a domain: data_reg and en_data_reg update
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    // clk_b domain: two-stage synchronization of enable signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: update output data based on en_clap_two
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            if (en_clap_two)
                dataout <= data_reg;
            else
                dataout <= dataout;
        end
    end

endmodule