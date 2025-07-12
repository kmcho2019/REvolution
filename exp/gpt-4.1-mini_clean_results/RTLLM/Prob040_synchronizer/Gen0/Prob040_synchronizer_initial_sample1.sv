module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

// Data register in clk_a domain
reg [3:0] data_reg;
// Enable register in clk_a domain
reg en_data_reg;

// Enable synchronization flip-flops in clk_b domain
reg en_clap_one;
reg en_clap_two;

// Update data_reg and en_data_reg on clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// Synchronize enable signal and update output on clk_b domain
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
        dataout     <= 4'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;

        if (en_clap_two)
            dataout <= data_reg;
        else
            dataout <= dataout;
    end
end

endmodule