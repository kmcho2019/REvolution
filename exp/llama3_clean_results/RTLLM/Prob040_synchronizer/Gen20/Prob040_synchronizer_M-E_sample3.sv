module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

// Data capture module
reg [3:0] data_cap;
reg req;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_cap <= 4'd0;
        req <= 1'b0;
    end else if (data_en) begin
        data_cap <= data_in;
        req <= 1'b1;
    end else begin
        req <= 1'b0;
    end
end

// Synchronization controller
reg ack;
reg [3:0] data_sync;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        ack <= 1'b0;
        data_sync <= 4'd0;
    end else if (req) begin
        ack <= 1'b1;
        data_sync <= data_cap;
    end else begin
        ack <= 1'b0;
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (ack) begin
        dataout <= data_sync;
    end
end

endmodule