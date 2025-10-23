module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Early data capture in clk_a domain (two-stage)
    reg [3:0] data_stage1, data_stage2;
    reg en_stage1, en_stage2;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_stage1 <= 4'b0;
            data_stage2 <= 4'b0;
            en_stage1 <= 1'b0;
            en_stage2 <= 1'b0;
        end else begin
            // First stage captures when enable is asserted
            if (data_en) begin
                data_stage1 <= data_in;
                en_stage1 <= 1'b1;
            end
            
            // Second stage provides stability
            data_stage2 <= data_stage1;
            en_stage2 <= en_stage1;
            
            // Clear enable after stable capture
            if (en_stage2) begin
                en_stage1 <= 1'b0;
            end
        end
    end

    // Predictive enable synchronization in clk_b domain
    reg en_sync_meta, en_sync;
    reg [3:0] data_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_meta <= 1'b0;
            en_sync <= 1'b0;
            data_sync <= 4'b0;
        end else begin
            // First stage of enable sync
            en_sync_meta <= en_stage2;
            
            // Second stage with data capture
            en_sync <= en_sync_meta;
            if (en_sync_meta) begin
                data_sync <= data_stage2;
            end
        end
    end

    // Output with change detection
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync && (dataout != data_sync)) begin
            dataout <= data_sync;
        end
    end

endmodule