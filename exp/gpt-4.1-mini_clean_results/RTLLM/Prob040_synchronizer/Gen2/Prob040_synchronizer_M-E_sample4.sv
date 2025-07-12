module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain, synchronous
    input  wire        brstn,      // active-low reset clk_b domain, synchronous
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // === clk_a domain registers ===
    reg [3:0]   data_reg_a;       // latch input data_in when data_en rises
    reg         data_en_dly;      // delayed data_en for edge detection
    reg         data_en_pulse;    // pulse generated on rising edge of data_en

    // === Pulse synchronizer to clk_b domain ===
    reg         pulse_sync_1, pulse_sync_2;
    wire        pulse_sync_edge;

    // === clk_b domain registers ===
    reg [3:0]   data_reg_b;       // latched data transferred to clk_b domain

    // ---------- clk_a domain logic ----------

    always @(posedge clk_a) begin
        if (!arstn) begin
            data_reg_a    <= 4'b0;
            data_en_dly   <= 1'b0;
            data_en_pulse <= 1'b0;
        end else begin
            data_en_dly <= data_en;

            // Detect rising edge of data_en
            data_en_pulse <= data_en & ~data_en_dly;

            // Latch data_in only when data_en rises (new valid data)
            if (data_en & ~data_en_dly) begin
                data_reg_a <= data_in;
            end
        end
    end

    // ---------- pulse synchronization to clk_b domain ----------

    // Synchronize pulse signal to clk_b domain with 2-flip-flop synchronizer
    always @(posedge clk_b) begin
        if (!brstn) begin
            pulse_sync_1 <= 1'b0;
            pulse_sync_2 <= 1'b0;
        end else begin
            pulse_sync_1 <= data_en_pulse;
            pulse_sync_2 <= pulse_sync_1;
        end
    end

    // Detect rising edge of synchronized pulse in clk_b domain
    assign pulse_sync_edge = pulse_sync_1 & ~pulse_sync_2;

    // ---------- clk_b domain data latch ----------

    always @(posedge clk_b) begin
        if (!brstn) begin
            data_reg_b <= 4'b0;
            dataout    <= 4'b0;
        end else begin
            if (pulse_sync_edge) begin
                // Load new data from clk_a domain sampled value
                data_reg_b <= data_reg_a;
                dataout    <= data_reg_a;
            end else begin
                // Hold previous output
                dataout <= dataout;
            end
        end
    end

endmodule