module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Integrated synchronization and data registers
    reg [3:0] data_sync1, data_sync2;
    reg en_sync1, en_sync2;
    
    // Clock gating control (static for this implementation)
    wire clk_en = data_en | en_sync1 | en_sync2;
    
    // Synchronizer and data update logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            data_sync1 <= 4'b0;
            data_sync2 <= 4'b0;
            dataout <= 4'b0;
        end else begin
            // First stage sync
            en_sync1 <= data_en;
            data_sync1 <= data_in;
            
            // Second stage sync and output update
            en_sync2 <= en_sync1;
            data_sync2 <= data_sync1;
            
            // Output update only when synchronized enable is high
            if (en_sync2) begin
                dataout <= data_sync2;
            end
        end
    end

endmodule