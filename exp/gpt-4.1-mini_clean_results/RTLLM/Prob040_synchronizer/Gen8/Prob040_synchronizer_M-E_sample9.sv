module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Register to capture data_in gated by data_en in clk_a domain with async reset
reg [3:0] data_reg_a;
reg       en_reg_a;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg_a <= 4'b0;
        en_reg_a <= 1'b0;
    end else begin
        if (data_en) begin
            data_reg_a <= data_in;
            en_reg_a <= 1'b1;
        end else begin
            en_reg_a <= 1'b0;
        end
    end
end

// Double flip-flop synchronizer for enable in clk_b domain
reg en_sync_1, en_sync_2;

// Double flip-flop synchronizer for data in clk_b domain
reg [3:0] data_sync_1, data_sync_2;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_sync_1 <= 1'b0;
        en_sync_2 <= 1'b0;
        data_sync_1 <= 4'b0;
        data_sync_2 <= 4'b0;
        dataout <= 4'b0;
    end else begin
        // Synchronize enable and data from clk_a domain
        en_sync_1 <= en_reg_a;
        en_sync_2 <= en_sync_1;
        data_sync_1 <= data_reg_a;
        data_sync_2 <= data_sync_1;

        // Update output only when delayed enable is high
        if (en_sync_2)
            dataout <= data_sync_2;
        else
            dataout <= dataout; // hold previous value
    end
end

endmodule