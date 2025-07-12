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
reg req;
reg ack;

// Transmitter module
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        req <= 1'b0;
        data_reg <= 4'd0;
    end else if (data_en) begin
        req <= 1'b1;
        data_reg <= data_in;
    end else begin
        req <= 1'b0;
    end
end

// Synchronizer for request signal
reg req_sync;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        req_sync <= 1'b0;
    end else begin
        req_sync <= req;
    end
end

// Receiver module
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        ack <= 1'b0;
        dataout <= 4'd0;
    end else if (req_sync) begin
        ack <= 1'b1;
        dataout <= data_reg;
    end else begin
        ack <= 1'b0;
    end
end

// Handshake controller
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        // Reset handshake signals
    end else if (ack) begin
        // Data transfer complete, reset request signal
        req <= 1'b0;
    end
end

endmodule