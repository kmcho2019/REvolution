module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A signals
    reg [3:0] data_reg;
    
    // Clock domain B signals
    reg en_sync_stage1;
    reg en_sync_stage2;
    
    // Clock domain A: Data capture
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else begin
            if (data_en) begin
                data_reg <= data_in;
            end
        end
    end
    
    // Clock domain B: First stage synchronizer
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage1 <= 1'b0;
        end else begin
            en_sync_stage1 <= data_en;
        end
    end
    
    // Clock domain B: Second stage synchronizer and output
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage2 <= 1'b0;
            dataout <= 4'b0;
        end else begin
            en_sync_stage2 <= en_sync_stage1;
            if (en_sync_stage2) begin
                dataout <= data_reg;
            end
        end
    end

endmodule