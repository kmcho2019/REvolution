module synchronizer (
    input         clk_a,
    input         clk_b,
    input         arstn,
    input         brstn,
    input  [3:0]  data_in,
    input         data_en,
    output reg [3:0] dataout
);

    // Register to store input data_in in clk_a domain
    reg [3:0] data_reg;

    // Register to store input enable data_en in clk_a domain
    reg en_data_reg;

    // Two-stage synchronizer registers in clk_b domain for en_data_reg
    reg en_clap_one;
    reg en_clap_two;

    // Data register and enable register update on clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg   <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg   <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Synchronize en_data_reg into clk_b domain with 2 flip-flops
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Output dataout update on clk_b domain, gated by en_clap_two
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            if (en_clap_two)
                dataout <= data_reg;
            else
                dataout <= dataout;
        end
    end

endmodule