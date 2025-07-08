module synchronizer (
    input              clk_a,
    input              clk_b,
    input              arstn,
    input              brstn,
    input      [3:0]   data_in,
    input              data_en,
    output reg [3:0]   dataout
);

// Data register in clk_a domain
reg [3:0] data_reg;
// Enable register in clk_a domain
reg       en_data_reg;

// Enable control registers in clk_b domain
reg en_clap_one;
reg en_clap_two;

// clk_a domain: sample data_in and data_en
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// clk_b domain: delay en_data_reg two cycles
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// clk_b domain: output dataout updated when en_clap_two is high
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else begin
        if (en_clap_two) begin
            dataout <= data_reg;
        end else begin
            dataout <= dataout; // Hold previous value
        end
    end
end

endmodule