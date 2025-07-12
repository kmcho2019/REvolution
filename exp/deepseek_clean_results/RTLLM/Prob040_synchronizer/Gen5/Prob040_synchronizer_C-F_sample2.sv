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
    
    // Clock domain B synchronization
    reg [1:0] en_sync_reg;
    
    // Data capture in clk_a domain - only when enabled
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end
    
    // Enable sync and output assignment in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_reg <= 2'b00;
            dataout <= 4'b0;
        end else begin
            // Two-stage synchronizer for metastability protection
            en_sync_reg <= {en_sync_reg[0], data_en};
            
            // Explicit output assignment when synchronized enable is active
            if (en_sync_reg[1]) begin
                dataout <= data_reg;
            end
        end
    end

endmodule