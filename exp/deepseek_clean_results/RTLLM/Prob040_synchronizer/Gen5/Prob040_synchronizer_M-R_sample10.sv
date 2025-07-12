module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A signals
    reg [3:0] captured_data;
    wire capture_enable = data_en;
    
    // Clock domain B signals
    reg sync_stage1, sync_stage2;
    wire synchronized_enable = sync_stage2;
    
    // Data capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            captured_data <= 4'b0;
        end else if (capture_enable) begin
            captured_data <= data_in;
        end
    end
    
    // Enable signal synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_stage1 <= 1'b0;
            sync_stage2 <= 1'b0;
        end else begin
            sync_stage1 <= capture_enable;
            sync_stage2 <= sync_stage1;
        end
    end
    
    // Output assignment in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= synchronized_enable ? captured_data : dataout;
        end
    end

endmodule