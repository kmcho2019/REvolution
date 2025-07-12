module synchronizer #(
    parameter WIDTH = 4
) (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [WIDTH-1:0] data_in,
    input wire data_en,
    output reg [WIDTH-1:0] dataout
);

    // clk_a domain registers
    reg [WIDTH-1:0] data_reg;
    reg en_data_reg;
    
    // clk_b domain registers
    reg en_sync_stage1;
    reg en_sync_stage2;
    reg [WIDTH-1:0] data_sync;

    // Data capture logic in clk_a domain
    wire data_change = (data_in != data_reg);
    wire data_reg_en = data_en & data_change;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= {WIDTH{1'b0}};
            en_data_reg <= 1'b0;
        end else begin
            if (data_reg_en) data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Two-stage enable synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage1 <= 1'b0;
            en_sync_stage2 <= 1'b0;
        end else begin
            en_sync_stage1 <= en_data_reg;
            en_sync_stage2 <= en_sync_stage1;
        end
    end

    // Output register in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= {WIDTH{1'b0}};
        end else begin
            if (en_sync_stage2) dataout <= data_reg;
        end
    end

endmodule