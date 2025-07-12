module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,       // async reset, active low, clk_a domain
    input  wire        brstn,       // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_buffer;          // latch input data when data_en is high
    reg       data_en_d1, data_en_d2;  // for pulse generation
    wire      data_en_pulse;

    // clk_b domain registers for synchronizing pulse
    reg pulse_sync_0, pulse_sync_1;
    wire pulse_sync_rising_edge;

    // ----------------------
    // clk_a domain logic
    // ----------------------
    // Generate single-cycle pulse when data_en goes high (rising edge detection)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_en_d1 <= 1'b0;
            data_en_d2 <= 1'b0;
            data_buffer <= 4'd0;
        end else begin
            data_en_d1 <= data_en;
            data_en_d2 <= data_en_d1;

            // Latch data_in only when data_en is high
            if (data_en)
                data_buffer <= data_in;
        end
    end

    assign data_en_pulse = data_en_d1 & ~data_en_d2;  // rising edge of data_en

    // ----------------------
    // clk_b domain logic
    // ----------------------
    // Two-stage synchronizer for data_en_pulse
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            pulse_sync_0 <= 1'b0;
            pulse_sync_1 <= 1'b0;
            dataout      <= 4'd0;
        end else begin
            pulse_sync_0 <= data_en_pulse;
            pulse_sync_1 <= pulse_sync_0;

            // Detect rising edge of synchronized pulse
            if (pulse_sync_0 & ~pulse_sync_1) begin
                dataout <= data_buffer;
            end
            // else retain previous dataout
        end
    end

endmodule