module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data register in clk_a domain
    reg [3:0] data_reg;
    reg en_reg;
    reg [3:0] prev_data_in;
    reg prev_data_en;
    
    // Clock A domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg <= 1'b0;
            prev_data_in <= 4'b0;
            prev_data_en <= 1'b0;
        end else begin
            prev_data_in <= data_in;
            prev_data_en <= data_en;
            
            // Only update when data_en is high and either data_in or data_en changes
            if (data_en && ((data_in != prev_data_in) || (data_en != prev_data_en))) begin
                data_reg <= data_in;
                en_reg <= data_en;
            end
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
            
            // Update output only when synchronized enable is high
            if (en_sync2) begin
                dataout <= data_reg;
            end
        end
    end

endmodule