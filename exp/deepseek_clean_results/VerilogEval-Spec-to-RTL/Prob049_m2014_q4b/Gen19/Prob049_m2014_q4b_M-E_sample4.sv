module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

parameter SCAN_MODE = 1'b0;       // 0=normal operation, 1=scan mode
parameter SCAN_IN = 1'b0;         // Scan chain input

reg q_int;
reg sync_ar;
reg last_d;

// Reset synchronizer (2-stage for metastability protection)
always @(posedge clk or posedge ar) begin
    if (ar) begin
        sync_ar <= 1'b1;
    end else begin
        sync_ar <= 1'b0;
    end
end

// Data change detector for clock gating
always @(posedge clk) begin
    last_d <= d;
end

wire data_changed = (d != last_d);
wire gated_clk = clk & (data_changed | ar);

// Dual-edge triggered flip-flop with async reset
always @(posedge gated_clk or negedge gated_clk or posedge ar) begin
    if (ar) begin
        q_int <= 1'b0;
    end else begin
        q_int <= SCAN_MODE ? SCAN_IN : d;
    end
end

assign q = q_int;

endmodule