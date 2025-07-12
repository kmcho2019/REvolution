module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // sync reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // --- clk_a domain registers ---
    reg [3:0] data_reg;          // Holds stable data sampled when data_en is high
    reg       data_en_d1, data_en_d2; // For edge detect of data_en
    reg       data_load_pulse;   // One-cycle pulse when data_en goes high

    // Generate a one-cycle pulse on clk_a when data_en rises (from 0 to 1)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_en_d1     <= 1'b0;
            data_en_d2     <= 1'b0;
            data_load_pulse <= 1'b0;
            data_reg       <= 4'd0;
        end else begin
            data_en_d1 <= data_en;
            data_en_d2 <= data_en_d1;
            data_load_pulse <= data_en_d1 & ~data_en_d2; // rising edge of data_en

            // Latch data_in only while data_en is high (stable period)
            if (data_en)
                data_reg <= data_in;
            // else hold previous value
        end
    end

    // --- Synchronize the load pulse from clk_a domain to clk_b domain ---
    // Double flip-flop synchronizer for pulse transfer
    reg pulse_sync_0, pulse_sync_1;
    reg load_enable; // Strobe in clk_b domain

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            pulse_sync_0 <= 1'b0;
            pulse_sync_1 <= 1'b0;
            load_enable  <= 1'b0;
        end else begin
            pulse_sync_0 <= data_load_pulse;
            pulse_sync_1 <= pulse_sync_0;

            // Detect rising edge of synchronized pulse_sync_1 to generate load_enable one cycle pulse
            load_enable <= pulse_sync_0 & ~pulse_sync_1;
        end
    end

    // --- clk_b domain registers holding synchronized data ---
    reg [3:0] data_buf;   // Registered data transferred into clk_b domain on load_enable pulse

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_buf <= 4'd0;
            dataout  <= 4'd0;
        end else begin
            if (load_enable) begin
                // On load enable pulse, sample data_reg via async signal stable enough on clk_a side
                data_buf <= data_reg;
                dataout  <= data_reg;
            end else begin
                // Hold previous output when no new load event
                dataout <= dataout;
            end
        end
    end

endmodule