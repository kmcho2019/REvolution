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
reg req, ack;

assign dataout = (en_delay[1] && ack) ? data_reg : dataout;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        req <= 1'b0;
    end else if (data_en) begin
        data_reg <= data_in;
        req <= 1'b1;
    end else begin
        req <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 2'd0;
        ack <= 1'b0;
    end else begin
        en_delay <= {en_delay[0], req};
        if (en_delay[1]) begin
            ack <= 1'b1;
        end else begin
            ack <= 1'b0;
        end
    end
end

endmodule