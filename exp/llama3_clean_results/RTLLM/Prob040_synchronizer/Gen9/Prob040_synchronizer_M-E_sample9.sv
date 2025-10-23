module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg_a;
reg [3:0] data_reg_b;
reg handshake_a;
reg handshake_b;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg_a <= 4'd0;
        handshake_a <= 1'b0;
    end else if (data_en) begin
        data_reg_a <= data_in;
        handshake_a <= 1'b1;
    end else begin
        handshake_a <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_reg_b <= 4'd0;
        handshake_b <= 1'b0;
        dataout <= 4'd0;
    end else begin
        handshake_b <= handshake_a;
        if (handshake_b) begin
            data_reg_b <= data_reg_a;
            dataout <= data_reg_b;
        end
    end
end

endmodule