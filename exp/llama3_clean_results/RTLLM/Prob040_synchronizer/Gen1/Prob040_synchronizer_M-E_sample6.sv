module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg req_sync;
reg req_sync_d;
reg ack;
reg [3:0] data_out_reg;

// Data Register
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

// Handshake Controller
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        req_sync <= 1'd0;
    end else if (data_en) begin
        req_sync <= 1'd1;
    end else begin
        req_sync <= 1'd0;
    end
end

// Synchronizer
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        req_sync_d <= 1'd0;
    end else begin
        req_sync_d <= req_sync;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        ack <= 1'd0;
    end else if (req_sync_d) begin
        ack <= 1'd1;
    end else begin
        ack <= 1'd0;
    end
end

// Output Controller
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        data_out_reg <= 4'd0;
    end else if (ack) begin
        data_out_reg <= data_reg;
    end
end

assign dataout = data_out_reg;

endmodule