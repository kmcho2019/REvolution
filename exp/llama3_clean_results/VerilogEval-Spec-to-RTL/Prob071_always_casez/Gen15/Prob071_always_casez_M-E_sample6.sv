module TopModule(
    input  [7:0] in,
    output [2:0] pos
);
    wire [3:0] mid;
    assign mid = (in[7:4] == 8'b0000) ? 4'd0 : 4'd1;
    
    always @(*) begin
        if (mid == 4'd0) begin
            if (in[3:0] == 4'b0000) begin
                pos = 3'd0;
            end else if (in[0]) begin
                pos = 3'd0;
            end else if (in[1]) begin
                pos = 3'd1;
            end else if (in[2]) begin
                pos = 3'd2;
            end else begin
                pos = 3'd3;
            end
        end else begin
            if (in[7:4] == 4'b0000) begin
                pos = 3'd0;
            end else if (in[4]) begin
                pos = 3'd4;
            end else if (in[5]) begin
                pos = 3'd5;
            end else if (in[6]) begin
                pos = 3'd6;
            end else begin
                pos = 3'd7;
            end
        end
    end
endmodule