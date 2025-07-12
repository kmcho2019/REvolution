module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

// Data Buffer (Dual-Clock FIFO)
reg [3:0] fifo_data[7:0];
reg [2:0] fifo_ptr_a;
reg [2:0] fifo_ptr_b;
reg       fifo_empty;
reg       fifo_full;

// Handshake Protocol
reg       req_a;
reg       ack_b;
reg       req_b;
reg       ack_a;

// Clock Domain Crossing (CDC) Logic
reg       cdc_req_a;
reg       cdc_ack_b;
reg       cdc_req_b;
reg       cdc_ack_a;

// Generate req signal in clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        req_a <= 1'b0;
        fifo_ptr_a <= 3'd0;
    end else if (data_en && !fifo_full) begin
        req_a <= 1'b1;
        fifo_data[fifo_ptr_a] <= data_in;
        fifo_ptr_a <= fifo_ptr_a + 1'b1;
    end else begin
        req_a <= 1'b0;
    end
end

// CDC Logic for req signal
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        cdc_req_a <= 1'b0;
    end else begin
        cdc_req_a <= req_a;
    end
end

// Generate ack signal in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        ack_b <= 1'b0;
        fifo_ptr_b <= 3'd0;
    end else if (cdc_req_a && !fifo_empty) begin
        ack_b <= 1'b1;
        dataout <= fifo_data[fifo_ptr_b];
        fifo_ptr_b <= fifo_ptr_b + 1'b1;
    end else begin
        ack_b <= 1'b0;
    end
end

// CDC Logic for ack signal
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        cdc_ack_b <= 1'b0;
    end else begin
        cdc_ack_b <= ack_b;
    end
end

// Update fifo_empty and fifo_full signals
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        fifo_empty <= 1'b1;
        fifo_full <= 1'b0;
    end else if (fifo_ptr_a == 8'd0) begin
        fifo_empty <= 1'b1;
    end else begin
        fifo_empty <= 1'b0;
    end
end

always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        fifo_full <= 1'b0;
    end else if (fifo_ptr_a == 8'd8) begin
        fifo_full <= 1'b1;
    end else begin
        fifo_full <= 1'b0;
    end
end

endmodule