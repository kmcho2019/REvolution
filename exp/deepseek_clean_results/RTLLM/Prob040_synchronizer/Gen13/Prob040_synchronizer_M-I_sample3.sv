module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data capture in clk_a domain
    reg [3:0] data_reg;
    reg en_reg;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg <= data_in;
                en_reg <= 1'b1;
            end else begin
                en_reg <= 1'b0;
            end
        end
    end

    // Single-stage enable synchronization in clk_b domain
    reg en_sync;
    reg [3:0] data_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 1'b0;
            data_sync <= 4'b0;
        end else begin
            en_sync <= en_reg;
            if (en_reg) begin
                data_sync <= data_reg;
            end
        end
    end

    // Output register
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync) begin
            dataout <= data_sync;
        end
    end

endmodule