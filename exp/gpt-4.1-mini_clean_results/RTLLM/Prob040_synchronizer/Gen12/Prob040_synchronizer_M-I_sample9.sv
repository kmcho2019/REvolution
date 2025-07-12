module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain (converted to sync)
    input  wire        brstn,      // async reset, active low, clk_b domain (converted to sync)
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;      // latch input data when data_en is high
    reg       en_data_reg;   // latched data_en for synchronization

    // Registers in clk_b domain for two-stage enable synchronization
    reg en_clap_one, en_clap_two;

    // Convert async reset to synchronous reset in clk_a domain
    reg arstn_sync;
    always @(posedge clk_a) begin
        arstn_sync <= arstn;
    end

    // clk_a domain: latch data_reg only when data_en is high, else hold previous value.
    // en_data_reg updates only when data_en is high, reducing toggle rate.
    always @(posedge clk_a) begin
        if (!arstn_sync) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg    <= data_in;
                en_data_reg <= 1'b1;
            end else begin
                en_data_reg <= 1'b0; // Clear to avoid stale enable, enables proper synchronization
            end
        end
    end

    // Convert async reset to synchronous reset in clk_b domain
    reg brstn_sync;
    always @(posedge clk_b) begin
        brstn_sync <= brstn;
    end

    // clk_b domain: two-stage synchronizer for en_data_reg to safely transfer enable signal,
    // and update dataout only when en_clap_two (delayed enable) is high.
    always @(posedge clk_b) begin
        if (!brstn_sync) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'd0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            if (en_clap_two)
                dataout <= data_reg;
            // else hold previous dataout value
        end
    end

endmodule