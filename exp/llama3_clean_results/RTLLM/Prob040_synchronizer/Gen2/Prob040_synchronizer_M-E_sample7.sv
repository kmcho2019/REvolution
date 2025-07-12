module synchronizer(
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_sync;
reg en_sync1;
reg en_sync2;
reg [3:0] data_mux;

always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_sync <= 0;
    end else begin
        data_sync <= data_in;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_sync1 <= 0;
        en_sync2 <= 0;
        data_mux <= 0;
        dataout <= 0;
    end else begin
        en_sync1 <= data_en;
        en_sync2 <= en_sync1;
        if (en_sync2) begin
            data_mux <= data_sync;
        end else begin
            data_mux <= data_mux;
        end
        dataout <= data_mux;
    end
end

endmodule