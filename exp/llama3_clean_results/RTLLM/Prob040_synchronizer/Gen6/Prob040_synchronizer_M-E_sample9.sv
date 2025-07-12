module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

// FIFO_A (located in clock domain A)
reg [3:0] fifo_a_data [7:0];
reg [2:0] fifo_a_ptr;
reg       fifo_a_empty;
reg       fifo_a_full;

// FIFO_B (located in clock domain B)
reg [3:0] fifo_b_data [7:0];
reg [2:0] fifo_b_ptr;
reg       fifo_b_empty;
reg       fifo_b_full;

// Handshake protocol
reg       req;
reg       ack;

// Control logic
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        fifo_a_ptr <= 3'd0;
        fifo_a_empty <= 1'b1;
        fifo_a_full <= 1'b0;
    end else if (data_en &&!fifo_a_full) begin
        fifo_a_data[fifo_a_ptr] <= data_in;
        fifo_a_ptr <= fifo_a_ptr + 1;
        fifo_a_empty <= 1'b0;
        if (fifo_a_ptr == 3'd7) begin
            fifo_a_full <= 1'b1;
        end
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        fifo_b_ptr <= 3'd0;
        fifo_b_empty <= 1'b1;
        fifo_b_full <= 1'b0;
    end else if (req &&!fifo_b_full) begin
        fifo_b_data[fifo_b_ptr] <= fifo_a_data[0];
        fifo_b_ptr <= fifo_b_ptr + 1;
        fifo_b_empty <= 1'b0;
        if (fifo_b_ptr == 3'd7) begin
            fifo_b_full <= 1'b1;
        end
        ack <= 1'b1;
    end else begin
        ack <= 1'b0;
    end
end

always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        req <= 1'b0;
    end else if (fifo_a_full &&!fifo_b_full) begin
        req <= 1'b1;
    end else begin
        req <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
    end else if (!fifo_b_empty) begin
        dataout <= fifo_b_data[0];
        fifo_b_ptr <= fifo_b_ptr - 1;
        if (fifo_b_ptr == 3'd0) begin
            fifo_b_empty <= 1'b1;
        end
    end
end

endmodule