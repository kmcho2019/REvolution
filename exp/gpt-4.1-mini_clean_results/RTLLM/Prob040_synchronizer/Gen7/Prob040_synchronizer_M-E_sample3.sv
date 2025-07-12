module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async active-low reset clk_a domain
    input  wire        brstn,      // async active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain: latch data_in once at rising edge of data_en
    reg [3:0] data_reg;
    reg       data_en_dly;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg   <= 4'b0;
            data_en_dly <= 1'b0;
        end else begin
            data_en_dly <= data_en;
            // latch data_in only on rising edge of data_en
            if (~data_en_dly & data_en) begin
                data_reg <= data_in;
            end
        end
    end

    // clk_b domain: 3-stage synchronizer for data_en (from clk_a domain)
    reg en_sync_0, en_sync_1, en_sync_2;
    reg [3:0] data_reg_clkb;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_0 <= 1'b0;
            en_sync_1 <= 1'b0;
            en_sync_2 <= 1'b0;
            dataout   <= 4'b0;
            data_reg_clkb <= 4'b0;
        end else begin
            // Synchronize data_en (from clk_a domain)
            en_sync_0 <= data_en;
            en_sync_1 <= en_sync_0;
            en_sync_2 <= en_sync_1;

            // Synchronize data_reg from clk_a domain to clk_b domain via direct latch at clk_b edge
            // Data changes only when data_en is asserted, which lasts at least 3 clk_b cycles,
            // so safe to sample data_reg at each clk_b edge without additional synchronization registers
            data_reg_clkb <= data_reg;

            // MUX-based output:
            // When en_sync_2 is high, output the new data_reg_clkb, else hold previous dataout
            if (en_sync_2)
                dataout <= data_reg_clkb;
            else
                dataout <= dataout;
        end
    end

endmodule