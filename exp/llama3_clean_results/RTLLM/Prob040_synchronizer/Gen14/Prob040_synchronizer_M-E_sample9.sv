module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_sync;
reg sync_pulse;
reg sync_pulse_d1;
reg sync_pulse_d2;

// Pulse generator
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        sync_pulse <= 1'b0;
        sync_pulse_d1 <= 1'b0;
        sync_pulse_d2 <= 1'b0;
    end else begin
        sync_pulse <= data_en;
        sync_pulse_d1 <= sync_pulse;
        sync_pulse_d2 <= sync_pulse_d1;
    end
end

// Data synchronizer
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_sync <= 4'd0;
    end else if (sync_pulse) begin
        data_sync <= data_in;
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (sync_pulse_d2) begin
        dataout <= data_sync;
    end
end

endmodule