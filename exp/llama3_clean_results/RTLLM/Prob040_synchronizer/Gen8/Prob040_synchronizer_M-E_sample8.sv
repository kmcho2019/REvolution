module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

reg [3:0] data_sync1;
reg [3:0] data_sync2;
reg       en_sync1;
reg       en_sync2;
reg       en_sync3;
reg       pulse_stretched;

always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_sync1  <= 4'd0;
        en_sync1   <= 1'd0;
    end else begin
        if (data_en) begin
            data_sync1  <= data_in;
        end
        en_sync1   <= data_en;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        data_sync2  <= 4'd0;
        en_sync2   <= 1'd0;
        en_sync3   <= 1'd0;
        pulse_stretched  <= 1'd0;
        dataout  <= 4'd0;
    end else begin
        data_sync2  <= data_sync1;
        en_sync2   <= en_sync1;
        en_sync3   <= en_sync2;
        pulse_stretched  <= en_sync2;
        if (en_sync3) begin
            dataout  <= data_sync2;
        end
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        pulse_stretched  <= 1'd0;
    end else begin
        if (en_sync2) begin
            pulse_stretched  <= 1'b1;
        end else if (~en_sync2 && pulse_stretched) begin
            pulse_stretched  <= 1'b1;
        end else begin
            pulse_stretched  <= 1'b0;
        end
    end
end

endmodule