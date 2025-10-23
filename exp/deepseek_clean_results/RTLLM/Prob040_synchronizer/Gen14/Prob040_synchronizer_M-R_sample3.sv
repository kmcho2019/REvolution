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
    reg en_data_reg;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else if (data_en) begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // First stage of synchronization in clk_b domain
    reg en_sync1;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
        end else begin
            en_sync1 <= en_data_reg;
        end
    end

    // Second stage of synchronization in clk_b domain
    reg en_sync2;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync2 <= 1'b0;
        end else begin
            en_sync2 <= en_sync1;
        end
    end

    // Output data register
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2) begin
            dataout <= data_reg;
        end
    end

endmodule