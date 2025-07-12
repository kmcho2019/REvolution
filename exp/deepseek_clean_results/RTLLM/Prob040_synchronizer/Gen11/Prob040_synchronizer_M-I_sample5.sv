module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Two-stage synchronizer registers with clock gating
    reg en_sync1, en_sync2;
    wire en_sync1_next = data_en;
    wire en_sync2_next = en_sync1;
    
    // Data register
    reg [3:0] data_reg;
    
    // Combined synchronization and data update logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout <= 4'b0;
            data_reg <= 4'b0;
        end else begin
            // Synchronizer chain
            en_sync1 <= en_sync1_next;
            en_sync2 <= en_sync2_next;
            
            // Data update only when enabled
            if (en_sync2) begin
                dataout <= data_in;
            end
            
            // Store current data for stability
            data_reg <= data_in;
        end
    end

endmodule