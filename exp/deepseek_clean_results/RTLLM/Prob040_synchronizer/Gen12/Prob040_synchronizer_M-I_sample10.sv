module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock gating control for data path
    reg [3:0] data_reg;
    reg [3:0] prev_data_reg;
    reg data_changed;
    reg en_data_reg;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            prev_data_reg <= 4'b0;
            en_data_reg <= 1'b0;
            data_changed <= 1'b0;
        end else if (data_en) begin  // Only update when enabled
            prev_data_reg <= data_reg;
            data_reg <= data_in;
            data_changed <= (data_in != data_reg);
            en_data_reg <= data_en;
        end
    end

    // Optimized two-stage enable synchronizer
    reg [1:0] en_sync_stages;
    wire en_sync = en_sync_stages[1] & data_changed;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stages <= 2'b00;
        end else begin
            en_sync_stages <= {en_sync_stages[0], en_data_reg};
        end
    end

    // Output register with optimized hold logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync) begin
            dataout <= data_reg;
        end
    end

endmodule