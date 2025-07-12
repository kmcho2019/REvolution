module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg_a;
    reg en_reg_a;

    // Clock domain B synchronization registers
    reg en_sync_stage1, en_sync_stage2;

    // Data capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_reg_a <= 1'b0;
        end else begin
            data_reg_a <= data_in;
            en_reg_a <= data_en;
        end
    end

    // Enable signal synchronization in clk_b domain
    // First stage - capture from clk_a domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage1 <= 1'b0;
        end else begin
            en_sync_stage1 <= en_reg_a;
        end
    end

    // Second stage - synchronized enable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage2 <= 1'b0;
        end else begin
            en_sync_stage2 <= en_sync_stage1;
        end
    end

    // Data output register
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync_stage2) begin
            dataout <= data_reg_a;
        end
    end

endmodule