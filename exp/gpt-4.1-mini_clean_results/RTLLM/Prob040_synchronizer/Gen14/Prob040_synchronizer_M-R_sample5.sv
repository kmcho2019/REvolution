module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Register to capture data_in when data_en is high, clk_a domain
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'd0;
        else if (data_en)
            data_reg <= data_in;
    end

    // Synchronize data_en from clk_a domain to clk_b domain with two flip-flop stages
    reg en_sync_stage1, en_sync_stage2;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage1 <= 1'b0;
            en_sync_stage2 <= 1'b0;
        end else begin
            en_sync_stage1 <= data_en;
            en_sync_stage2 <= en_sync_stage1;
        end
    end

    // Delay en_sync_stage2 by one more clock cycle (third stage)
    reg en_sync_stage3;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_stage3 <= 1'b0;
        end else begin
            en_sync_stage3 <= en_sync_stage2;
        end
    end

    // Update dataout on clk_b domain according to delayed enable signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'd0;
        else if (en_sync_stage3)
            dataout <= data_reg;
        // else retain previous value (implicit)
    end

endmodule