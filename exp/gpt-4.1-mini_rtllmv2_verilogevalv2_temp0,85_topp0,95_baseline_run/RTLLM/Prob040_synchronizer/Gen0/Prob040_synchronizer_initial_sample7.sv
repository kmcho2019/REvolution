module synchronizer (
    input              clk_a,
    input              clk_b,
    input              arstn,    // async active-low reset for clk_a domain
    input              brstn,    // async active-low reset for clk_b domain
    input      [3:0]   data_in,
    input              data_en,
    output reg [3:0]   dataout
);

// Registers in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

// Registers in clk_b domain
reg       en_clap_one;
reg       en_clap_two;

// Data and enable registering in clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// Enable synchronizer in clk_b domain (two flip-flops)
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output data register in clk_b domain gated by synchronized enable
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end
    // else retain previous dataout
end

endmodule