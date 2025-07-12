module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] sender_data_reg;
reg sender_req;
reg receiver_ack;
reg [3:0] receiver_data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        sender_data_reg <= 4'd0;
        sender_req <= 1'b0;
    end else if (data_en) begin
        sender_data_reg <= data_in;
        sender_req <= 1'b1;
    end else if (receiver_ack) begin
        sender_req <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        receiver_data_reg <= 4'd0;
        receiver_ack <= 1'b0;
    end else if (sender_req) begin
        receiver_data_reg <= sender_data_reg;
        receiver_ack <= 1'b1;
    end else if (!sender_req) begin
        receiver_ack <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (receiver_ack) begin
        dataout <= receiver_data_reg;
    end
end

endmodule