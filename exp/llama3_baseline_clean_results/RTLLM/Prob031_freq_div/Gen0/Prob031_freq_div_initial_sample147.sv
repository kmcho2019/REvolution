module freq_div(
    input  logic CLK_in,
    input  logic RST,
    output logic CLK_50,
    output logic CLK_10,
    output logic CLK_1
);

logic [1:0] cnt_10;
logic [5:0] cnt_100;

always_ff @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 2'd0;
        cnt_100 <= 6'd0;
        CLK_1 <= 1'b0;
    end else begin
        CLK_50 <= ~CLK_50;
        
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 == 4'd9) begin
            cnt_10 <= 4'd0;
            CLK_10 <= ~CLK_10;
        end
        
        cnt_100 <= cnt_100 + 1;
        if (cnt_100 == 6'd99) begin
            cnt_100 <= 6'd0;
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule