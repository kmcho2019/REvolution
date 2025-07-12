module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

    // Data and enable registers in clk_a domain, async reset
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

    // Enable synchronization register as 2-bit shift register in clk_b domain
    reg [1:0] en_sync;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b00;
        end else begin
            en_sync <= {en_sync[0], en_data_reg};
        end
    end

    wire en_clap_two = en_sync[1];

    // Output register update on clk_b, with mux for output data
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= en_clap_two ? data_reg : dataout;
        end
    end

endmodule