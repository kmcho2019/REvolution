module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

    // Register data_in on clk_a domain only when data_en is high
    reg [3:0] data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'b0;
        else if (data_en)
            data_reg <= data_in;
    end

    // Synchronize data_en from clk_a to clk_b domain with 2 flip-flops
    reg en_sync_1, en_sync_2;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_1 <= 1'b0;
            en_sync_2 <= 1'b0;
        end else begin
            en_sync_1 <= data_en;
            en_sync_2 <= en_sync_1;
        end
    end

    // Update output dataout in clk_b domain when en_sync_2 is high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0;
        else if (en_sync_2)
            dataout <= data_reg;
        // else keep previous value
    end

endmodule