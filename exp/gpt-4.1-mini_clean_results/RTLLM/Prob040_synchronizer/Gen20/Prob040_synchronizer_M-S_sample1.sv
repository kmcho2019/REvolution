module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

reg [3:0] data_reg;
reg       en_sync_1, en_sync_2;
reg       data_en_reg;

// Capture data_in and data_en on clk_a domain with async reset
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg     <= 4'b0;
        data_en_reg  <= 1'b0;
    end else begin
        data_reg     <= data_in;
        data_en_reg  <= data_en;
    end
end

// Synchronize data_en_reg to clk_b domain via two flip-flops with async reset
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_sync_1 <= 1'b0;
        en_sync_2 <= 1'b0;
    end else begin
        en_sync_1 <= data_en_reg;
        en_sync_2 <= en_sync_1;
    end
end

// Update output dataout in clk_b domain when synchronized enable is high
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) 
        dataout <= 4'b0;
    else if (en_sync_2)
        dataout <= data_reg;
end

endmodule