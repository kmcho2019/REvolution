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
    reg [3:0] data_reg;
    reg       data_en_dly;

    // Handshake signals: pulse when data_en rises
    wire data_en_rise = data_en & ~data_en_dly;

    // Send "new_data" pulse as handshake bit 0,
    // and toggle handshake bit 1 for ack in clk_b domain
    reg handshake_a;     // toggled on each new_data pulse in clk_a domain
    reg handshake_a_dly;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg      <= 4'd0;
            data_en_dly   <= 1'b0;
            handshake_a   <= 1'b0;
            handshake_a_dly <= 1'b0;
        end else begin
            data_en_dly <= data_en;

            // Latch data_in only when data_en is high (stable period)
            if (data_en) begin
                data_reg <= data_in;
            end

            handshake_a_dly <= handshake_a;
            // On rising edge of data_en, toggle handshake_a to signal new data
            if (data_en_rise) begin
                handshake_a <= ~handshake_a;
            end
        end
    end

    // Synchronize handshake_a crossing clk_a to clk_b domain
    reg handshake_b_ff1, handshake_b_ff2;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            handshake_b_ff1 <= 1'b0;
            handshake_b_ff2 <= 1'b0;
        end else begin
            handshake_b_ff1 <= handshake_a;
            handshake_b_ff2 <= handshake_b_ff1;
        end
    end

    // Capture previous handshake value to detect toggle
    reg handshake_b_ff2_dly;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            handshake_b_ff2_dly <= 1'b0;
        end else begin
            handshake_b_ff2_dly <= handshake_b_ff2;
        end
    end

    // When handshake toggles in clk_b domain, latch data_reg (sampled async)
    // For data cross domain transfer, use a special register with "clk_a" sample
    // Declare a register to asynchronously sample data_reg with clk_b clock
    // But data_reg changes slowly and is stable for at least 3 clk_b cycles while data_en high,
    // so reading it directly in clk_b domain after handshake toggling is acceptable.
    reg [3:0] data_reg_async;

    // As data_reg is from clk_a domain, use a gray code or multi-flip flop register
    // But since data changes very slowly and data_en is at least 3 clk_b cycles,
    // it is safe to use a sampled data_reg on clk_b domain immediately after handshake toggling.

    // To implement safe data transfer, latch data_reg into a register in clk_b domain at handshake toggle
    // Use a buffer to hold data sampled in clk_a domain (actually the last latched data_reg)
    // Using a flag to update dataout when handshake toggles

    // Since data_reg is clk_a domain, latch it into a signal and then double sync handshake for safe domain crossing
    // So here we sample data_reg in clk_a and send handshake to clk_b to indicate data valid.

    // For reading data_reg in clk_b domain safely, double-register data_reg in clk_a domain to reduce metastability risk:
    reg [3:0] data_reg_a; // Register stable data_reg version for reading

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'd0;
        end else begin
            data_reg_a <= data_reg;
        end
    end

    // Register to hold synchronized data in clk_b domain
    reg [3:0] dataout_next;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
            dataout_next <= 4'd0;
            handshake_b_ff2_dly <= 1'b0;
        end else begin
            // Detect handshake toggle (edge)
            if (handshake_b_ff2 != handshake_b_ff2_dly) begin
                // On handshake toggle, update output with stable data_reg_a
                // Since data_reg_a is clk_a domain registered data, treat it as async input here,
                // but data_en is high and stable for enough cycles to ensure data_reg_a is stable.
                dataout_next <= data_reg_a;
            end
            // Update output register with dataout_next (hold if no new data)
            dataout <= dataout_next;
        end
    end

endmodule