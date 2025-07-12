module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

// Gray-coded converter
reg [3:0] gray_data;
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        gray_data <= 4'd0;
    end else if (data_en) begin
        gray_data <= data_in ^ (data_in >> 1);
    end
end

// Dual-clock FIFO
reg [3:0] fifo_data [7:0];
reg [2:0] fifo_ptr;
reg fifo_empty;
reg fifo_full;
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        fifo_ptr <= 3'd0;
        fifo_empty <= 1'd1;
        fifo_full <= 1'd0;
    end else if (data_en) begin
        if (~fifo_full) begin
            fifo_data[fifo_ptr] <= gray_data;
            fifo_ptr <= fifo_ptr + 1;
            if (fifo_ptr == 3'd7) begin
                fifo_full <= 1'd1;
            end
            fifo_empty <= 1'd0;
        end
    end
end

reg [3:0] fifo_out;
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        fifo_out <= 4'd0;
    end else if (~fifo_empty) begin
        fifo_out <= fifo_data[0];
        for (int i = 1; i < 8; i++) begin
            fifo_data[i-1] <= fifo_data[i];
        end
        fifo_ptr <= fifo_ptr - 1;
        if (fifo_ptr == 3'd0) begin
            fifo_empty <= 1'd1;
            fifo_full <= 1'd0;
        end
    end
end

// Output assignment
reg [3:0] output_data;
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        output_data <= 4'd0;
    end else if (~fifo_empty) begin
        output_data <= fifo_out;
    end
end

assign dataout = output_data;

endmodule