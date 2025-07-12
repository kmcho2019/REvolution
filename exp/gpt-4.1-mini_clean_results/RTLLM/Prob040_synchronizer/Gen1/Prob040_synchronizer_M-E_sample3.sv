module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,     // active-low reset clk_a domain
    input  wire        brstn,     // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       en_reg;            // Registered data_en
    reg       pulse_gen;         // pulse signal for new data
    reg       pulse_gen_d;       // delayed pulse_gen for edge detection

    // clk_b domain synchronizer for pulse signal
    reg pulse_sync_0;
    reg pulse_sync_1;
    reg pulse_sync_2;

    // clk_b domain latched data
    reg [3:0] data_latched;

    // Generate pulse_gen when data_en rises (single clk_a cycle pulse)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_reg      <= 1'b0;
            pulse_gen   <= 1'b0;
            pulse_gen_d <= 1'b0;
            data_reg    <= 4'b0;
        end else begin
            en_reg <= data_en;
            // Detect rising edge of data_en
            pulse_gen <= (~en_reg) & data_en;
            pulse_gen_d <= pulse_gen;

            // Update data_reg only when data_en is high to reduce toggling
            if (data_en) begin
                data_reg <= data_in;
            end
        end
    end

    // Synchronize pulse_gen signal into clk_b domain with 3-stage synchronizer for safety
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            pulse_sync_0 <= 1'b0;
            pulse_sync_1 <= 1'b0;
            pulse_sync_2 <= 1'b0;
        end else begin
            pulse_sync_0 <= pulse_gen;
            pulse_sync_1 <= pulse_sync_0;
            pulse_sync_2 <= pulse_sync_1;
        end
    end

    // Detect rising edge of synchronized pulse in clk_b domain and latch data_reg
    reg pulse_sync_1_d;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            pulse_sync_1_d <= 1'b0;
            data_latched   <= 4'b0;
            dataout       <= 4'b0;
        end else begin
            pulse_sync_1_d <= pulse_sync_1;
            // On rising edge of pulse_sync_1, latch data_reg into data_latched
            if (pulse_sync_1 & ~pulse_sync_1_d) begin
                data_latched <= data_reg;
            end
            dataout <= data_latched; // hold last latched value
        end
    end

endmodule