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
reg [1:0] en_delay;
reg req_a, ack_b;
reg [1:0] gray_counter;

assign dataout = (ack_b) ? data_reg : dataout;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        req_a <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        req_a <= 1'b1;
    end else begin
        req_a <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 2'd0;
        ack_b <= 1'b0;
        gray_counter <= 2'd0;
    end else if (req_a) begin
        en_delay <= {en_delay[0], 1'b1};
        ack_b <= 1'b1;
        gray_counter <= gray_counter + 1'b1;
    end else begin
        ack_b <= 1'b0;
    end
end

endmodule