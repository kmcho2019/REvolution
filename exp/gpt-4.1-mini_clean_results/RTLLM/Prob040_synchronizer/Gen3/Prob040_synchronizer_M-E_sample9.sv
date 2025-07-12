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
    reg [3:0] data_reg;
    reg       data_en_reg;
    reg       data_toggle;           // toggled each time valid new data captured

    // Registers for synchronizing toggle signal into clk_b domain
    reg sync_toggle_ff1, sync_toggle_ff2;
    reg prev_sync_toggle;

    // Internal register to hold data transferred to clk_b domain
    reg [3:0] data_latched;

    // clk_a domain: capture data_in and data_en, toggle data_toggle when data_en rises
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg     <= 4'b0;
            data_en_reg  <= 1'b0;
            data_toggle  <= 1'b0;
        end else begin
            data_en_reg <= data_en;
            if (data_en && !data_en_reg) begin
                // Rising edge of data_en: capture data_in and toggle flag
                data_reg    <= data_in;
                data_toggle <= ~data_toggle;
            end
            // else hold previous data_reg and toggle
        end
    end

    // clk_b domain: synchronize data_toggle using 2-stage synchronizer
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_toggle_ff1 <= 1'b0;
            sync_toggle_ff2 <= 1'b0;
            prev_sync_toggle <= 1'b0;
            data_latched   <= 4'b0;
            dataout        <= 4'b0;
        end else begin
            // Synchronize toggle
            sync_toggle_ff1 <= data_toggle;
            sync_toggle_ff2 <= sync_toggle_ff1;

            // Detect toggle edge (new data indication)
            if (sync_toggle_ff2 != prev_sync_toggle) begin
                data_latched   <= data_reg;       // latch data_reg into clk_b domain
                dataout        <= data_reg;       // update output
                prev_sync_toggle <= sync_toggle_ff2;
            end else begin
                dataout <= dataout;               // hold output implicitly
            end
        end
    end

endmodule