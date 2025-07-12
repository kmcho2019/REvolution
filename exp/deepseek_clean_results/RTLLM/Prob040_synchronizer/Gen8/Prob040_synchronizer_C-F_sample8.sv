module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data capture in clk_a domain with optimized clock gating
    reg [3:0] data_reg;
    reg en_data_reg;
    wire clk_a_gated = clk_a & (data_en | ~arstn);

    always @(posedge clk_a_gated or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Two-stage synchronizer with enable-based operation
    reg en_sync1, en_sync2;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            {en_sync1, en_sync2} <= 2'b00;
        end else begin
            // Only update when enable changes to reduce power
            if (en_data_reg ^ en_sync1) begin
                en_sync1 <= en_data_reg;
                en_sync2 <= en_sync1;
            end
        end
    end

    // Output data register with conditional update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2) begin
            dataout <= data_reg;
        end
    end

endmodule