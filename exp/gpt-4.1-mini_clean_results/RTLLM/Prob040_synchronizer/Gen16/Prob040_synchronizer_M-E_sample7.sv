module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// --- clk_a domain ---
// Register to hold latched data when data_en is high
reg [3:0] latched_data;
reg       data_en_d1, data_en_d2;  // for edge detect of data_en

// Pulse generator: detect rising edge of data_en
wire data_en_rise = data_en & ~data_en_d1;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        latched_data <= 4'b0;
        data_en_d1 <= 1'b0;
        data_en_d2 <= 1'b0;
    end else begin
        data_en_d1 <= data_en;
        data_en_d2 <= data_en_d1;
        if (data_en) begin
            // latch data_in while data_en is high and stable
            latched_data <= data_in;
        end
    end
end

wire pulse_a = data_en_rise;

// --- Synchronize pulse_a into clk_b domain using 2-stage synchronizer ---
reg pulse_b_ff1, pulse_b_ff2;
wire pulse_b_sync;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        pulse_b_ff1 <= 1'b0;
        pulse_b_ff2 <= 1'b0;
    end else begin
        pulse_b_ff1 <= pulse_a;
        pulse_b_ff2 <= pulse_b_ff1;
    end
end
assign pulse_b_sync = pulse_b_ff1 & ~pulse_b_ff2; // pulse detected on clk_b domain (rising edge)

// --- Synchronize latched_data into clk_b domain with two-stage synchronizer for each bit ---
reg [3:0] data_b_ff1, data_b_ff2;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_b_ff1 <= 4'b0;
        data_b_ff2 <= 4'b0;
    end else begin
        data_b_ff1 <= latched_data;
        data_b_ff2 <= data_b_ff1;
    end
end

// --- Output update in clk_b domain ---
// Update dataout only when pulse_b_sync pulses indicating new valid data

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (pulse_b_sync) begin
        dataout <= data_b_ff2;
    end // else hold current dataout
end

endmodule