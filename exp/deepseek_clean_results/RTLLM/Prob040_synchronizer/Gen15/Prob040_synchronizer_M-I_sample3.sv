module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Shared reset signal for synchronizer stages
    wire sync_reset = !brstn;
    
    // Two-stage enable synchronizer in clk_b domain
    reg en_sync_stage1, en_sync_stage2;
    wire en_sync_stage2_posedge = !en_sync_stage2 && en_sync_stage1; // Detect rising edge
    
    // Clock gating control
    wire output_clk_en = en_sync_stage2_posedge || !brstn;
    wire gated_clk_b;
    
    // Clock gating cell
    CLKAND output_clk_gate (
        .A(clk_b),
        .B(output_clk_en),
        .Z(gated_clk_b)
    );
    
    // Synchronizer and output registers
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage1 <= 1'b0;
            en_sync_stage2 <= 1'b0;
        end else begin
            en_sync_stage1 <= data_en;
            en_sync_stage2 <= en_sync_stage1;
        end
    end
    
    // Output register with gated clock and enable-based update
    always @(posedge gated_clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= data_in;
        end
    end

endmodule