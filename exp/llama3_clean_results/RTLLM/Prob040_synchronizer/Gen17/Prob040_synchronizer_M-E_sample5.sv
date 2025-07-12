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
reg [1:0] en_cnt;
reg pulse;
reg ack;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_cnt <= 2'd0;
        pulse <= 1'b0;
    end else begin
        if (data_en) begin
            en_cnt <= en_cnt + 1'd1;
            if (en_cnt == 2'd2) begin
                pulse <= 1'b1;
            end
        end else begin
            en_cnt <= 2'd0;
            pulse <= 1'b0;
        end
        if (pulse) begin
            data_reg <= data_in;
        end
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
        ack <= 1'b0;
    end else begin
        if (pulse) begin
            dataout <= data_reg;
            ack <= 1'b1;
        end else begin
            ack <= 1'b0;
        end
    end
end

endmodule