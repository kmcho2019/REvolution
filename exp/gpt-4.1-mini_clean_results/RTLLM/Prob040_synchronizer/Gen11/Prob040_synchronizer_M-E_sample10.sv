module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,     // async reset active low clk_a domain
    input             brstn,     // async reset active low clk_b domain
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

//-------------------------------
// clk_a domain signals
reg [3:0] data_latched;
reg       data_valid_toggle;    // toggle to indicate new data

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_latched       <= 4'b0;
        data_valid_toggle  <= 1'b0;
    end else begin
        if (data_en) begin
            data_latched <= data_in;
            data_valid_toggle <= ~data_valid_toggle; // toggle on enable high
        end
        // if data_en low, keep previous data and toggle unchanged
    end
end

//-------------------------------
// clk_b domain synchronization of toggle signal

reg data_valid_sync_0, data_valid_sync_1;
reg data_valid_sync_2; // delayed version to detect toggle edge

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_valid_sync_0 <= 1'b0;
        data_valid_sync_1 <= 1'b0;
        data_valid_sync_2 <= 1'b0;
        dataout <= 4'b0;
    end else begin
        // double flop synchronizer for toggle signal crossing clk domains
        data_valid_sync_0 <= data_valid_toggle;
        data_valid_sync_1 <= data_valid_sync_0;

        // detect toggle edge
        data_valid_sync_2 <= data_valid_sync_1;

        // If toggle changed, latch new data
        if (data_valid_sync_1 ^ data_valid_sync_2) begin
            dataout <= data_latched;
        end
        // else hold previous dataout
    end
end

endmodule