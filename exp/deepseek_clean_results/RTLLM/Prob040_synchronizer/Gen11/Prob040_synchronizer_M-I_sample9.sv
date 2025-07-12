module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock gating control for data_reg updates
    wire data_reg_clken = data_en | ~arstn;
    reg [3:0] data_reg;
    reg en_data_reg;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else if (data_reg_clken) begin  // Clock-gated update
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Packed two-stage enable synchronizer in clk_b domain
    reg [1:0] en_sync_stages;
    
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
        end else if (en_sync_stages[1]) begin
            dataout <= data_reg;
        end
    end

endmodule