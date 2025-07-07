module synchronizer (
    input         clk_a,
    input         clk_b,
    input         arstn,
    input         brstn,
    input  [3:0]  data_in,
    input         data_en,
    output reg [3:0] dataout
);

    // Register to store data_in on clk_a domain
    reg [3:0] data_reg;
    // Register to store data_en on clk_a domain
    reg       en_data_reg;

    // Two-stage enable synchronizer on clk_b domain
    reg en_clap_one;
    reg en_clap_two;

    // Data and enable registers on clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Enable synchronizer on clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Output data register on clk_b domain
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