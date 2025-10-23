module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A register (synchronous reset)
    reg [3:0] data_reg;
    
    // Clock domain B synchronization
    reg en_sync_reg = 1'b0;
    reg data_en_prev = 1'b0;
    
    // Data capture in clk_a domain
    always @(posedge clk_a) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end
    
    // Enable sync and output assignment in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_reg <= 1'b0;
            dataout <= 4'b0;
            data_en_prev <= 1'b0;
        end else begin
            // Only update sync register when enable changes
            data_en_prev <= data_en;
            if (data_en_prev != data_en) begin
                en_sync_reg <= data_en;
            end
            
            if (en_sync_reg) begin
                dataout <= data_reg;
            end
        end
    end

endmodule