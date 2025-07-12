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

// Request generation in clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        req <= 1'b0;
    end else if (data_en) begin
        req <= 1'b1;
    end else begin
        req <= 1'b0;
    end
end

// Acknowledgement generation in clk_b domain
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        ack <= 1'b0;
    end else if (req) begin
        ack <= 1'b1;
    end else begin
        ack <= 1'b0;
    end
end

// Data transmission
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (req && ack) begin
        dataout <= data_in;
    end
end

endmodule