module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Registers clocked by clk_a
reg [3:0] data_reg;
reg       en_data_reg;

// Registers clocked by clk_b
reg en_clap_one, en_clap_two;

// Data register and enable register on clk_a domain with asynchronous reset (active low)
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'd0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// Two-stage enable synchronization on clk_b domain with asynchronous reset (active low)
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output register with enable control on clk_b domain with asynchronous reset (active low)
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end else begin
        dataout <= dataout; // hold previous value
    end
end

endmodule