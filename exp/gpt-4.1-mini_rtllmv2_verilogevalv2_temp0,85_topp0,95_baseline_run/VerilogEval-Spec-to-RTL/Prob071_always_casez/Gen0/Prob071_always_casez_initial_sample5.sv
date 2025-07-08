module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);
    always @(*) begin
        casex (in)
            8'b00000001: pos = 3'd0;
            8'b0000001x: pos = 3'd0;
            8'b0000001x: pos = 3'd0;
            8'b0000001x: pos = 3'd0;
            8'b0000001x: pos = 3'd0;
        endcase
    end
endmodule