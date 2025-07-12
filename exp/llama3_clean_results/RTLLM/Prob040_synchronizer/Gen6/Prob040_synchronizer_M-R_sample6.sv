module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg       en_data_reg;
reg       en_data_sync;
reg       en_data_sync_d;

// Update data_reg and en_data_reg in clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end else begin
        en_data_reg <= 1'b0;
    end
end

// Synchronize en_data_reg from clock domain A to clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_data_sync <= 1'b0;
        en_data_sync_d <= 1'b0;
    end else begin
        en_data_sync <= en_data_reg;
        en_data_sync_d <= en_data_sync;
    end
end

// Update dataout in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
    end else if (en_data_sync && en_data_sync_d) begin
        dataout <= data_reg;
    end else begin
        dataout <= dataout;
    end
end

endmodule