module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data register in clk_a domain (only updates when data_en changes)
    reg [3:0] data_reg;
    reg en_reg;
    reg data_en_prev;
    
    // Clock A domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg <= 1'b0;
            data_en_prev <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            // Only update when enable changes or when newly enabled
            if (data_en && (!data_en_prev || (data_in != data_reg))) begin
                data_reg <= data_in;
            end
            en_reg <= data_en;
        end
    end

    // Two-stage synchronizer in clk_b domain
    reg en_sync1, en_sync2;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout <= 4'b0;
        end else begin
            en_sync1 <= en_reg;
            en_sync2 <= en_sync1;
            // Simplified output assignment
            dataout <= en_sync2 ? data_reg : dataout;
        end
    end

endmodule