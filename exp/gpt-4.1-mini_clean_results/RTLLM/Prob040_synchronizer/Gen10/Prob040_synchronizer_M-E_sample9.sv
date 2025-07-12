module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;        // latched stable data when data_en falls
    reg       en_data_reg;     // delayed data_en for edge detect in clk_a domain
    reg       en_data_dly;     // previous data_en for edge detect in clk_a domain

    // Generate a pulse on falling edge of data_en in clk_a domain to latch data_in
    wire latch_pulse = en_data_dly & ~en_data_reg;

    // Store data_en delayed by 1 clk_a cycle
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
            en_data_dly <= 1'b0;
        end else begin
            en_data_dly <= en_data_reg;
            en_data_reg <= data_en;
        end
    end

    // Latch data_in into data_reg only when latch_pulse occurs (data_en falling edge)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
        end else if (latch_pulse) begin
            data_reg <= data_in;
        end
    end

    // Synchronize the data_en signal crossing into clk_b domain with a 2-stage synchronizer
    reg en_b_sync_0, en_b_sync_1;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_b_sync_0 <= 1'b0;
            en_b_sync_1 <= 1'b0;
        end else begin
            en_b_sync_0 <= en_data_reg;    // sampled from clk_a domain (async cross)
            en_b_sync_1 <= en_b_sync_0;
        end
    end

    // Use the 2-stage synced enable in clk_b domain to generate a hold signal for dataout update
    // When en_b_sync_1 is high for at least 3 clk_b cycles (guaranteed by problem),
    // output dataout updates to data_reg on every clk_b rising edge while enable is high.
    reg [1:0] en_hold_cnt;  // count clk_b cycles enable has been high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_hold_cnt <= 2'd0;
        end else begin
            if (en_b_sync_1)
                en_hold_cnt <= (en_hold_cnt == 2'd3) ? 2'd3 : en_hold_cnt + 1;
            else
                en_hold_cnt <= 2'd0;
        end
    end

    // dataout updates only when en_hold_cnt >= 2 (to ensure stable enable held for at least 3 clk_b cycles)
    // otherwise, dataout holds previous value
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            if (en_hold_cnt >= 2'd2)
                dataout <= data_reg;
        end
    end

endmodule