module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Two-stage synchronizer registers
    reg en_sync1, en_sync2;
    reg [3:0] data_reg;
    
    // Clock gating optimization for enable path
    wire en_update = data_en | en_sync1 | en_sync2;
    
    // Combined synchronization and data update logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout <= 4'b0;
            data_reg <= 4'b0;
        end else begin
            // Synchronizer chain
            en_sync1 <= data_en;
            en_sync2 <= en_sync1;
            
            // Data capture and update
            if (en_sync2) begin
                data_reg <= data_in;
            end
            
            // Output update only when needed
            if (en_sync2) begin
                dataout <= data_in;
            end else if (!en_update) begin
                dataout <= dataout;  // Hold value when no updates
            end
        end
    end

endmodule