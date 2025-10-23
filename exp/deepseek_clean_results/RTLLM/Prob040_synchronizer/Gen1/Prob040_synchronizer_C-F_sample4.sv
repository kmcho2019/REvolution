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
    reg [3:0] data_reg;
    reg en_data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Clock domain B synchronization registers
    reg en_sync_stage1, en_sync_stage2;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage1 <= 1'b0;
            en_sync_stage2 <= 1'b0;
        end else begin
            en_sync_stage1 <= en_data_reg;
            en_sync_stage2 <= en_sync_stage1;
        end
    end

    // Clock domain B output register
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            if (en_sync_stage2) begin
                dataout <= data_reg;
            end
            // else retain previous value
        end
    end

endmodule