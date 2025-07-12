module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data synchronization registers
    reg [3:0] data_reg;
    reg [3:0] data_sync1, data_sync2;
    
    // Enable synchronization registers
    reg en_reg;
    reg en_sync1, en_sync2;
    
    // Clock A domain (input side)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_reg <= data_en;
        end
    end
    
    // Clock B domain (synchronization)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            // First stage sync
            data_sync1 <= 4'b0;
            en_sync1 <= 1'b0;
            
            // Second stage sync
            data_sync2 <= 4'b0;
            en_sync2 <= 1'b0;
        end else begin
            // First stage sync
            data_sync1 <= data_reg;
            en_sync1 <= en_reg;
            
            // Second stage sync
            data_sync2 <= data_sync1;
            en_sync2 <= en_sync1;
        end
    end
    
    // Output logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2) begin
            dataout <= data_sync2;
        end
    end

endmodule