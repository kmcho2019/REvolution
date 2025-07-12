module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

always @(*) begin
    if (in[0] == 1'b1) begin
        pos = 3'd0;
    end else if (in[1] == 1'b1) begin
        pos = 3'd1;
    end else if (in[2] == 1'b1) begin
        pos = 3'd2;
    end else if (in[3] == 1'b1) begin
        pos = 3'd3;
    end else if (in[4] == 1'b1) begin
        pos = 3'd4;
    end else if (in[5] == 1'b1) begin
        pos = 3'd5;
    end else if (in[6] == 1'b1) begin
        pos = 3'd6;
    end else if (in[7] == 1'b1) begin
        pos = 3'd7;
    end else begin
        pos = 3'd0;
    end
end

endmodule