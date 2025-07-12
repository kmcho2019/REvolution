module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data register in clk_a domain
    reg [3:0] data_reg;

    // Enable synchronization registers in clk_b domain
    reg en_clap_one, en_clap_two;

    // Data capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end
        else if (data_en) begin
            data_reg <= data_in;
        end
    end

    // Enable synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end
        else begin
            en_clap_one <= data_en;
            en_clap_two <= en_clap_one;
        end
    end

    // Data output in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end
        else if (en_clap_two) begin
            dataout <= data_reg;
        end
    end

endmodule