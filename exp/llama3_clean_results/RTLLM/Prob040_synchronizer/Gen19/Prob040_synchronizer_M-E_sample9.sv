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
reg [3:0] dataout_reg;
reg send_flag;
reg ack_flag;
reg handshake;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        send_flag <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        send_flag <= 1'b1;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout_reg <= 4'd0;
        ack_flag <= 1'b0;
        handshake <= 1'b0;
    end else begin
        if (send_flag && !ack_flag) begin
            dataout_reg <= data_reg;
            ack_flag <= 1'b1;
            handshake <= 1'b1;
        end else if (ack_flag && !send_flag) begin
            ack_flag <= 1'b0;
            handshake <= 1'b0;
        end
    end
end

assign dataout = dataout_reg;

endmodule