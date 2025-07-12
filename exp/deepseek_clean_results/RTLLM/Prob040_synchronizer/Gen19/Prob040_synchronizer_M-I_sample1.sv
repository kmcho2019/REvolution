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
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else if (data_en) begin  // Only update when enabled
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Clock domain B synchronizer
    // Two-stage sync for metastability protection
    // Plus output stage makes 3 cycles total (meets requirement)
    reg en_sync_meta, en_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_meta <= 1'b0;
            en_sync <= 1'b0;
            dataout <= 4'b0;
        end else begin
            en_sync_meta <= en_data_reg;
            en_sync <= en_sync_meta;
            if (en_sync) begin
                dataout <= data_reg;
            end
        end
    end

endmodule