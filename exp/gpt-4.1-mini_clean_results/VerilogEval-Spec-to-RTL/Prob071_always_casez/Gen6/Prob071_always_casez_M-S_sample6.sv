module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    casez ({in, 1'b0})
        9'b1???????_?: pos = 3'd0;
        9'b01??????_?: pos = 3'd1;
        9'b001?????_?: pos = 3'd2;
        9'b0001????_?: pos = 3'd3;
        9'b00001???_?: pos = 3'd4;
        9'b000001??_?: pos = 3'd5;
        9'b0000001?_?: pos = 3'd6;
        9'b00000001_?: pos = 3'd7;
        default:        pos = 3'd0;
    endcase
end

endmodule