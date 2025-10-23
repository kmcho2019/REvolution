module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain B synchronization
    reg [1:0] en_sync_reg = 2'b00;
    reg [3:0] data_sync_reg;
    
    // Enable sync in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_reg <= 2'b00;
            dataout <= 4'b0;
        end else begin
            en_sync_reg <= {en_sync_reg[0], data_en};
            
            // Capture data when enable is synchronized
            if (en_sync_reg[0]) begin
                data_sync_reg <= data_in;
            end
            
            // Output when enable is fully synchronized
            if (en_sync_reg[1]) begin
                dataout <= data_sync_reg;
            end
        end
    end

endmodule