module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] gray_code;

always @(posedge clk) begin
    if (reset) begin
        gray_code <= 4'd0;
    end else begin
        gray_code <= {gray_code[2:0], ~gray_code[3] & gray_code[2] | gray_code[3] & ~gray_code[2]};
    end
end

always @(*) begin
    case (gray_code)
        4'd0: q = 4'd0;
        4'd1: q = 4'd1;
        4'd3: q = 4'd2;
        4'd2: q = 4'd3;
        4'd6: q = 4'd4;
        4'd7: q = 4'd5;
        4'd5: q = 4'd6;
        4'd4: q = 4'd7;
        4'd12: q = 4'd8;
        4'd13: q = 4'd9;
        default: q = 4'd0;
    endcase
end

endmodule