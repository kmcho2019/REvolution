module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] buffer;
reg req;
reg ack;
reg sync_req;
reg sync_ack;

// Input side
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        req <= 1'b0;
        buffer <= 4'd0;
    end else if (data_en) begin
        req <= 1'b1;
        buffer <= data_in;
    end else if (ack) begin
        req <= 1'b0;
    end
end

// Synchronize request signal to clk_b
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        sync_req <= 1'b0;
    end else begin
        sync_req <= req;
    end
end

// Output side
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
        ack <= 1'b0;
    end else if (sync_req) begin
        dataout <= buffer;
        ack <= 1'b1;
    end else begin
        ack <= 1'b0;
    end
end

// Synchronize acknowledge signal to clk_a
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        sync_ack <= 1'b0;
    end else begin
        sync_ack <= ack;
    end
end

assign ack = sync_ack;

endmodule