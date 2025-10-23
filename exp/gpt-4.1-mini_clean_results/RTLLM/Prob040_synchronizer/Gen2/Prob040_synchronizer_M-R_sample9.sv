module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Register input data on clk_a domain
reg [3:0] data_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        data_reg <= 4'd0;
    else
        data_reg <= data_in;
end

// Register input enable on clk_a domain
reg en_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        en_reg <= 1'b0;
    else
        en_reg <= data_en;
end

// Synchronize enable signal into clk_b domain using 2-bit shift register
reg [1:0] en_sync;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        en_sync <= 2'b00;
    else
        en_sync <= {en_sync[0], en_reg};
end

wire en_sync_two = en_sync[1];

// Update output data on clk_b domain when enable is synchronized high
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'd0;
    else
        dataout <= en_sync_two ? data_reg : dataout;
end

endmodule