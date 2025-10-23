module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data register in clk_a domain (only updates when data_en changes)
    reg [3:0] data_reg;
    reg en_data_reg;
    reg data_en_prev;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
            data_en_prev <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            if (data_en && !data_en_prev) begin  // Only capture data on rising edge of data_en
                data_reg <= data_in;
            end
            en_data_reg <= data_en;
        end
    end

    // Synchronizer flip-flops in clk_b domain
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

    // Output register in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
    end

endmodule