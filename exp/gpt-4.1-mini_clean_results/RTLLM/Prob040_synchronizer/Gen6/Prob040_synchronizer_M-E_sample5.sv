module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain (async)
    input  wire        brstn,      // active-low reset clk_b domain (async)
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg_a;
    reg       send_data_a;

    // Synchronizer for send_data pulse crossing clk_a -> clk_b domain
    reg send_data_b_sync_0;
    reg send_data_b_sync_1;

    // Previous state of send_data_b_sync_1 in clk_b domain to detect rising edge
    reg send_data_b_sync_1_d;

    // clk_b domain data register
    reg [3:0] data_reg_b;

    // ---- clk_a domain: latch data_in on data_en rising and generate send_data pulse ----
    // To generate a single-cycle pulse for send_data_a on rising edge of data_en
    reg data_en_d;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a   <= 4'b0;
            send_data_a  <= 1'b0;
            data_en_d    <= 1'b0;
        end else begin
            data_en_d <= data_en;
            send_data_a <= 1'b0;  // default

            if (~data_en_d & data_en) begin
                // Rising edge of data_en: latch data_in and assert pulse
                data_reg_a <= data_in;
                send_data_a <= 1'b1;
            end
            // else hold data_reg_a, no update
        end
    end

    // ---- clk_b domain: synchronize send_data_a (pulse) ----
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            send_data_b_sync_0 <= 1'b0;
            send_data_b_sync_1 <= 1'b0;
            send_data_b_sync_1_d <= 1'b0;
        end else begin
            send_data_b_sync_0 <= send_data_a;
            send_data_b_sync_1 <= send_data_b_sync_0;
            send_data_b_sync_1_d <= send_data_b_sync_1;
        end
    end

    // ---- clk_b domain: on rising edge of synchronized pulse, latch data from clk_a domain ----
    // Since data_reg_a is in clk_a domain, to read it safely in clk_b domain,
    // we rely on slow data change and stable data_in during data_en.
    // Use a handshake: data_reg_a changes only on data_en rising edge,
    // so capturing data_reg_a at the clk_b rising edge of pulse is safe.

    // To transfer data_reg_a to clk_b domain correctly, instantiate a multi-bit synchronizer:
    // Given the low frequency of data changes and stable data_in, a direct register transfer is acceptable here.

    reg [3:0] data_reg_a_sync_0;
    reg [3:0] data_reg_a_sync_1;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_reg_a_sync_0 <= 4'b0;
            data_reg_a_sync_1 <= 4'b0;
        end else begin
            // Double-register synchronization of data_reg_a to clk_b domain continuously
            data_reg_a_sync_0 <= data_reg_a;
            data_reg_a_sync_1 <= data_reg_a_sync_0;
        end
    end

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_reg_b <= 4'b0;
            dataout    <= 4'b0;
        end else begin
            // Detect rising edge of synchronized pulse
            if (send_data_b_sync_1 & ~send_data_b_sync_1_d) begin
                // Load data from synchronized data_reg_a into clk_b domain register
                data_reg_b <= data_reg_a_sync_1;
            end
            // Update output with data_reg_b
            dataout <= data_reg_b;
        end
    end

endmodule