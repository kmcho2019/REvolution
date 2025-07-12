module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg req;
reg ack;

// Transmitter (clk_a domain)
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        req <= 1'd0;
        data_reg <= 4'd0;
    end else if (data_en) begin
        req <= 1'd1;
        data_reg <= data_in;
    end else if (ack) begin
        req <= 1'd0;
    end
end

// Receiver (clk_b domain)
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        ack <= 1'd0;
        dataout <= 4'd0;
    end else if (req) begin
        ack <= 1'd1;
        dataout <= data_reg;
    end else begin
        ack <= 1'd0;
    end
end

endmodule