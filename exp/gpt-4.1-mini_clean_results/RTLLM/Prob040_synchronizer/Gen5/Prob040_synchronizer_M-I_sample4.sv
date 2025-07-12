module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

// Data register: latch data_in when data_en is high, clocked by clk_a
reg [3:0] data_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        data_reg <= 4'b0;
    else if (data_en)
        data_reg <= data_in;
end

// Enable register: latch data_en in clk_a domain
reg en_data_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        en_data_reg <= 1'b0;
    else
        en_data_reg <= data_en;
end

// Enable control registers in clk_b domain: two D flip-flops delay
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

// Output data register update with enable gating to reduce toggling
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'b0;
    else if (en_clap_two)
        dataout <= data_reg;
    else
        dataout <= dataout; // Hold previous value when enable is low
end

endmodule