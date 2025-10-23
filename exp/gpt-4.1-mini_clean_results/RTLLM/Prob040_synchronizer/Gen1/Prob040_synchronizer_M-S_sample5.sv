module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Register input data and enable in clk_a domain
reg [3:0] data_reg;
reg       en_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_reg   <= 1'b0;
    end else begin
        data_reg <= data_in;
        en_reg   <= data_en;
    end
end

// Synchronize enable signal into clk_b domain with two flip-flops
reg en_sync_1, en_sync_2;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_sync_1 <= 1'b0;
        en_sync_2 <= 1'b0;
    end else begin
        en_sync_1 <= en_reg;
        en_sync_2 <= en_sync_1;
    end
end

// Update output data on clk_b domain when enable is synchronized high, else hold previous
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_sync_2) begin
        dataout <= data_reg;
    end
end

endmodule