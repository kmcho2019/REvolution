module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock gating for data_reg
    wire clk_a_gated = clk_a & (data_en | !arstn);
    
    // Data capture in clk_a domain - only update when enabled
    reg [3:0] data_reg;
    reg en_data_reg;
    
    always @(posedge clk_a_gated or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Single-stage enable synchronizer in clk_b domain (sufficient given 3-cycle requirement)
    reg en_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 1'b0;
        end else begin
            en_sync <= en_data_reg;
        end
    end

    // Output register with conditional update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync) begin
            dataout <= data_reg;
        end
    end

endmodule