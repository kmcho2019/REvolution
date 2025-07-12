module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] seq_det;

always @(posedge clk) begin
    if(reset) begin
        seq_det <= 4'b0000;
        start_shifting <= 0;
    end else begin
        seq_det <= {seq_det[2:0], data};
        if(seq_det == 4'b1101) begin
            start_shifting <= 1;
        end else if(start_shifting == 1 && reset) begin
            start_shifting <= 0;
        end
    end
end

endmodule