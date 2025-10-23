module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

//------------------------------------------------------------------
// CLK_A domain: Latch stable data and generate data_en rising pulse
//------------------------------------------------------------------
reg [3:0] data_reg_a;
reg data_en_dly_a;
reg data_en_pulse_a;  // Single-cycle pulse on rising edge of data_en

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg_a <= 4'b0;
        data_en_dly_a <= 1'b0;
        data_en_pulse_a <= 1'b0;
    end else begin
        // Latch data_in when data_en is high (data_in stable during data_en asserted)
        if (data_en)
            data_reg_a <= data_in;

        // Detect rising edge of data_en to generate pulse
        data_en_pulse_a <= data_en & ~data_en_dly_a;
        data_en_dly_a <= data_en;
    end
end

//------------------------------------------------------------
// Transfer pulse from clk_a domain to clk_b domain synchronizer
//------------------------------------------------------------
// Two-stage synchronizer for the pulse signal to clk_b domain
reg pulse_sync_ff1, pulse_sync_ff2;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        pulse_sync_ff1 <= 1'b0;
        pulse_sync_ff2 <= 1'b0;
    end else begin
        pulse_sync_ff1 <= data_en_pulse_a;
        pulse_sync_ff2 <= pulse_sync_ff1;
    end
end

//------------------------------------------------------------
// Detect pulse rising edge in clk_b domain to update dataout
//------------------------------------------------------------
// Pulse edge detector in clk_b domain
reg pulse_sync_ff2_dly;
wire pulse_rising_edge_b = (pulse_sync_ff2 & ~pulse_sync_ff2_dly);

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        pulse_sync_ff2_dly <= 1'b0;
        dataout <= 4'b0;
    end else begin
        pulse_sync_ff2_dly <= pulse_sync_ff2;

        if (pulse_rising_edge_b) begin
            // On new data pulse, update output with latest data from clk_a domain register
            // For safety, sample data_reg_a into clk_b domain via a multi-bit synchronizer latch
            // Since data_reg_a comes from clk_a, directly using it risks metastability.
            // However, per problem constraints, data_in changes very slowly and is stable during data_en high,
            // so direct latch is acceptable for this low-frequency update.
            // Alternatively, create a 4-bit synchronizer for data_reg_a here if needed for robustness.

            // Latch data_reg_a via simple register (this register crosses clock domains asynchronously)
            // The metastability risk is low given data stability and slow change rate.
            dataout <= data_reg_a;
        end
        // else hold previous value
    end
end

endmodule