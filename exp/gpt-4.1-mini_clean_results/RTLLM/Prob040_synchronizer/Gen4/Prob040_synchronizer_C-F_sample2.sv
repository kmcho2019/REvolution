module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async active-low reset for clk_a domain
    input  wire        brstn,      // async active-low reset for clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // ------------------------------------------------------------------------
    // clk_a domain: sample data_in and data_en without gating data_reg by data_en
    // This simplifies timing and ensures data_reg tracks latest data_in at clk_a
    // ------------------------------------------------------------------------
    reg [3:0] data_reg;
    reg       en_data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    // ------------------------------------------------------------------------
    // clk_b domain: Synchronize and filter enable signal from clk_a domain using
    // a 3-bit shift register to ensure stable enable for at least two clk_b cycles.
    // ------------------------------------------------------------------------
    reg [2:0] en_shift;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_shift <= 3'b000;
        end else begin
            // Shift in sampled enable signal from clk_a domain (en_data_reg)
            en_shift <= {en_shift[1:0], en_data_reg};
        end
    end

    // ------------------------------------------------------------------------
    // clk_b domain: Two-stage synchronizer for multi-bit data_reg crossing clk domains
    // to protect against metastability for data signals.
    // This samples data_reg asynchronously with respect to clk_b.
    // ------------------------------------------------------------------------
    reg [3:0] data_sync_stage1;
    reg [3:0] data_sync_stage2;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_sync_stage1 <= 4'd0;
            data_sync_stage2 <= 4'd0;
        end else begin
            data_sync_stage1 <= data_reg;
            data_sync_stage2 <= data_sync_stage1;
        end
    end

    // ------------------------------------------------------------------------
    // clk_b domain: Output register dataout updated only when enable is stable
    // for at least two clk_b cycles (all bits in en_shift are 1).
    // Otherwise, dataout holds previous value.
    // ------------------------------------------------------------------------
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            if (&en_shift) begin
                dataout <= data_sync_stage2;
            end
            // else hold previous value implicitly (no else needed)
        end
    end

endmodule