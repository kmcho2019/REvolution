module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

    // clk_a domain registers: capture data_in and data_en with async reset
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

    // clk_b domain enable synchronizer registers with async reset
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

    // mux for data output update controlled by synchronized enable in clk_b domain
    wire [3:0] mux_dataout = en_clap_two ? data_reg : dataout;

    // clk_b domain output register with async reset
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0;
        else
            dataout <= mux_dataout;
    end

endmodule