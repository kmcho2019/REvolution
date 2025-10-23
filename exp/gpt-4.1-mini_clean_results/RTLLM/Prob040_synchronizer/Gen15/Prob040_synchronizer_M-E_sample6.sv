module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,       // async reset, active low, clk_a domain
    input  wire        brstn,       // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // -- clk_a domain signals --
    reg [3:0] data_reg;          // Latch data_in when data_en is high
    reg       toggle_a;          // Toggle flag to indicate new data ready
    reg       data_en_d;         // Registered data_en to detect rising edge in clk_a domain

    // -- clk_b domain signals --
    reg        toggle_b1, toggle_b2;  // Synchronizers for toggle_a crossing clk domains
    reg        toggle_b_sync;          // Synchronized toggle flag in clk_b domain
    reg [3:0]  data_sync_reg;          // Data latch in clk_b domain updated when new data arrives
    reg        toggle_b_sync_d;        // Previous toggle snapshot in clk_b domain

    // -------- clk_a domain --------
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg   <= 4'd0;
            toggle_a   <= 1'b0;
            data_en_d  <= 1'b0;
        end else begin
            data_en_d <= data_en;
            // When data_en goes high (rising edge), latch data_in and toggle toggle_a
            if (data_en && !data_en_d) begin
                data_reg <= data_in;
                toggle_a <= ~toggle_a;  // toggle to indicate new data ready
            end
            // When data_en remains high or low, data_reg holds previous value
            // toggle_a only toggles on rising edge of data_en
        end
    end

    // -------- clk_b domain --------
    // Synchronize toggle_a into clk_b domain to detect new data availability
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            toggle_b1       <= 1'b0;
            toggle_b2       <= 1'b0;
            toggle_b_sync   <= 1'b0;
            toggle_b_sync_d <= 1'b0;
            data_sync_reg   <= 4'd0;
            dataout         <= 4'd0;
        end else begin
            // Two-stage synchronizer for toggle signal
            toggle_b1     <= toggle_a;
            toggle_b2     <= toggle_b1;
            toggle_b_sync <= toggle_b2;

            toggle_b_sync_d <= toggle_b_sync;

            // Detect toggle change (new data arrived)
            if (toggle_b_sync != toggle_b_sync_d) begin
                // Latch data from clk_a domain register
                // It is assumed data_reg is stable long enough per spec
                // Use data_reg as a cross-domain source synchronized via handshake
                data_sync_reg <= data_reg;
                dataout       <= data_reg;
            end
            // else hold previous dataout
        end
    end

endmodule