module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,       // async reset, active low, clk_a domain
    input  wire        brstn,       // sync reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // In clk_a domain:
    // Register to hold stable data_in captured only at rising edge of data_en
    reg [3:0] data_reg;
    reg       data_en_dly;  // delayed data_en to detect rising edge

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            data_en_dly <= 1'b0;
        end else begin
            data_en_dly <= data_en;
            // Capture data_in only on rising edge of data_en
            if (~data_en_dly & data_en)
                data_reg <= data_in;
        end
    end

    // In clk_b domain:
    // 3-stage synchronizer for the enable signal crossing clk_a->clk_b
    reg en_sync_stage1, en_sync_stage2, en_sync_stage3;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage1 <= 1'b0;
            en_sync_stage2 <= 1'b0;
            en_sync_stage3 <= 1'b0;
        end else begin
            en_sync_stage1 <= data_en;
            en_sync_stage2 <= en_sync_stage1;
            en_sync_stage3 <= en_sync_stage2;
        end
    end

    // MUX-based synchronizer controlled by delayed enable (en_sync_stage3)
    // Hold previous dataout when enable is low, update with synchronized data_reg when enable is high
    wire [3:0] mux_data;
    assign mux_data = en_sync_stage3 ? data_reg : dataout;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            dataout <= mux_data;
        end
    end

endmodule