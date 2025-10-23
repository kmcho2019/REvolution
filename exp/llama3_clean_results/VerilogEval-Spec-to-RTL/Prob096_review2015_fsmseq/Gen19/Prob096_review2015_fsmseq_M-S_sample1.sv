module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] seq_det = 4'b0000;

always @(*) begin
    if(reset) begin
        seq_det = 4'b0000;
        start_shifting = 0;
    end else begin
        if(seq_det == 4'b1101) begin
            start_shifting = 1;
        end else begin
            start_shifting = 0;
        end
    end
end

always @(posedge clk) begin
    if(reset) begin
        seq_det <= 4'b0000;
    end else begin
        case(seq_det)
            4'b0000: seq_det <= (data == 1'b1)? 4'b0001 : 4'b0000;
            4'b0001: seq_det <= (data == 1'b1)? 4'b0011 : 4'b0000;
            4'b0011: seq_det <= (data == 1'b0)? 4'b0110 : 4'b0000;
            4'b0110: seq_det <= (data == 1'b1)? 4'b1101 : 4'b0000;
            4'b1101: seq_det <= 4'b1101;
            default: seq_det <= 4'b0000;
        endcase
    end
end

endmodule