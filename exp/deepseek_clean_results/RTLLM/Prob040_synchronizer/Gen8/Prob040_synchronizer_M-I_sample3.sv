module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A register (only capture data when enabled)
    reg [3:0] data_reg;
    reg data_en_prev;
    
    // Clock domain B synchronization
    reg en_sync_reg;
    
    // Data capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            data_en_prev <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            if (data_en) begin
                data_reg <= data_in;
            end
        end
    end
    
    // Enable sync and output assignment in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_reg <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Only update sync reg when enable changes (power saving)
            if (data_en_prev != data_en) begin
                en_sync_reg <= data_en;
            end
            
            if (en_sync_reg) begin
                dataout <= data_reg;
            end
        end
    end

endmodule