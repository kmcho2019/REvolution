module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] gray_data_in;
reg gray_data_en;

// Gray code encoding
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        gray_data_in <= 4'd0;
        gray_data_en <= 1'b0;
    end else begin
        gray_data_in <= data_in;
        gray_data_en <= data_en;
    end
end

// Double-flop synchronizer for data
reg [3:0] data_sync1;
reg [3:0] data_sync2;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_sync1 <= 4'd0;
    end else begin
        data_sync1 <= gray_data_in;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_sync2 <= 4'd0;
    end else begin
        data_sync2 <= data_sync1;
    end
end

// Double-flop synchronizer for enable
reg enable_sync1;
reg enable_sync2;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        enable_sync1 <= 1'b0;
    end else begin
        enable_sync1 <= gray_data_en;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        enable_sync2 <= 1'b0;
    end else begin
        enable_sync2 <= enable_sync1;
    end
end

// FIFO to handle transient errors
reg [3:0] fifo_data [2:0];
reg [2:0] fifo_ptr;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        fifo_ptr <= 3'd0;
        fifo_data[0] <= 4'd0;
        fifo_data[1] <= 4'd0;
        fifo_data[2] <= 4'd0;
    end else if (enable_sync2) begin
        fifo_data[fifo_ptr] <= data_sync2;
        fifo_ptr <= (fifo_ptr + 1) % 3;
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (enable_sync2) begin
        dataout <= fifo_data[fifo_ptr];
    end
end

endmodule