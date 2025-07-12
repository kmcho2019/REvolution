module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_sync1;
reg [3:0] data_sync2;
reg en_sync1;
reg en_sync2;
reg [1:0] counter;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_sync1 <= 4'd0;
        en_sync1 <= 1'b0;
    end else if (data_en) begin
        data_sync1 <= data_in;
        en_sync1 <= 1'b1;
    end else begin
        data_sync1 <= data_sync1;
        en_sync1 <= en_sync1;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_sync2 <= 4'd0;
        en_sync2 <= 1'b0;
        counter <= 2'd0;
    end else begin
        data_sync2 <= data_sync1;
        en_sync2 <= en_sync1;
        if (en_sync2) begin
            if (counter == 2'd2) begin
                dataout <= data_sync2;
            end
            counter <= counter + 1'b1;
        end else begin
            counter <= 2'd0;
        end
    end
end

endmodule