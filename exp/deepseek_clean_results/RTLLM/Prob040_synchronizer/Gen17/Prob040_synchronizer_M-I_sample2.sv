module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Synchronization registers
    reg en_sync;
    reg [3:0] data_reg;
    wire en_sync_gated = data_en & ~en_sync;
    
    // Enable synchronization (clock domain B)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 1'b0;
        end else if (en_sync_gated) begin
            en_sync <= 1'b1;
        end else if (!data_en) begin
            en_sync <= 1'b0;
        end
    end
    
    // Data capture (clock domain A)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end
    
    // Output assignment (clock domain B)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync) begin
            dataout <= data_reg;
        end
    end

endmodule