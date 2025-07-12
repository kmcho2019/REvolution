module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg;
    reg en_data_reg;
    
    // Clock domain B synchronization
    reg [1:0] en_sync_reg = 2'b00;
    wire en_synced = en_sync_reg[1];
    
    // Data path in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end
    
    // Enable synchronization as shift register
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_reg <= 2'b00;
        end else begin
            en_sync_reg <= {en_sync_reg[0], en_data_reg};
        end
    end
    
    // Output assignment
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_synced) begin
            dataout <= data_reg;
        end
    end

endmodule