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
    reg data_en_reg;
    
    // Clock domain B signals
    reg [1:0] en_sync_stage;
    reg [3:0] data_sync_reg;
    
    // Clock domain A: Data and enable capture
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            data_en_reg <= 1'b0;
        end else begin
            data_en_reg <= data_en;
            if (data_en) begin
                data_reg <= data_in;
            end
        end
    end
    
    // Clock domain B: Two-stage synchronizer with enable gating
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage <= 2'b00;
            data_sync_reg <= 4'b0;
            dataout <= 4'b0;
        end else begin
            // Enable synchronization
            en_sync_stage <= {en_sync_stage[0], data_en_reg};
            
            // Data synchronization when enable is stable
            if (en_sync_stage[0]) begin
                data_sync_reg <= data_reg;
            end
            
            // Output update only when synchronized enable is high
            if (en_sync_stage[1]) begin
                dataout <= data_sync_reg;
            end
        end
    end

endmodule