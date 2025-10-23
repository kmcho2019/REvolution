module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

// Gray code counter in clock domain A
reg [2:0] gray_counter_a;
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        gray_counter_a <= 3'd0;
    end else begin
        gray_counter_a <= gray_counter_a + 1'd1;
    end
end

// Synchronized Gray code counter in clock domain B
reg [2:0] gray_counter_b;
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        gray_counter_b <= 3'd0;
    end else begin
        gray_counter_b <= gray_counter_a;
    end
end

// Data synchronization register
reg [3:0] data_sync;
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        data_sync <= 4'd0;
    end else if (gray_counter_b == 3'd0 && data_en) begin
        data_sync <= data_in;
    end
end

// Output staging register
reg [3:0] data_out_reg;
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        data_out_reg <= 4'd0;
    end else if (gray_counter_b == 3'd1 && data_en) begin
        data_out_reg <= data_sync;
    end
end

assign dataout = data_out_reg;

endmodule