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

// Clock Domain Crossing (CDC) module
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        req <= 1'b0;
    end else if (data_en) begin
        req <= 1'b1;
    end else if (ack) begin
        req <= 1'b0;
    end
end

// Data synchronizer module
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        ack <= 1'b0;
        dataout <= 4'd0;
    end else if (req) begin
        ack <= 1'b1;
        dataout <= data_in;
    end else if (!req) begin
        ack <= 1'b0;
    end
end

// Data register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

endmodule