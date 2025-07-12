module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;       // hold input data
    reg       en_data_reg;    // latched enable
    reg       data_toggle;    // toggled to indicate new data latched

    // clk_b domain toggle synchronizer (2-stage)
    reg toggle_sync_1, toggle_sync_2;

    // clk_b domain data_en synchronizer (2-stage)
    reg en_clap_one, en_clap_two;

    // clk_b domain previous toggle to detect edge
    reg prev_toggle;

    // clk_b domain registered stable data
    reg [3:0] data_latched;

    // clk_a domain: latch data and toggle data_toggle on data_en asserted
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
            data_toggle <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en) begin
                data_reg <= data_in;
                data_toggle <= ~data_toggle; // toggle to signal new data
            end
        end
    end

    // clk_b domain: synchronize data_toggle signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            toggle_sync_1 <= 1'b0;
            toggle_sync_2 <= 1'b0;
        end else begin
            toggle_sync_1 <= data_toggle;
            toggle_sync_2 <= toggle_sync_1;
        end
    end

    // clk_b domain: synchronize en_data_reg (enable) from clk_a domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: detect toggle edge and latch data accordingly
    wire toggle_edge = (toggle_sync_2 != prev_toggle);

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            prev_toggle  <= 1'b0;
            data_latched <= 4'd0;
            dataout     <= 4'd0;
        end else begin
            prev_toggle <= toggle_sync_2;
            if (toggle_edge && en_clap_two) begin
                // Update data_latched and output only on toggle edge and enable synchronized
                data_latched <= data_reg;
                dataout <= data_reg;
            end
            // else hold previous value
        end
    end

endmodule