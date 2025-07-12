module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    case (count)
        4'd1: count <= (reset) ? 4'd1 : 4'd2;
        4'd2: count <= (reset) ? 4'd1 : 4'd3;
        4'd3: count <= (reset) ? 4'd1 : 4'd4;
        4'd4: count <= (reset) ? 4'd1 : 4'd5;
        4'd5: count <= (reset) ? 4'd1 : 4'd6;
        4'd6: count <= (reset) ? 4'd1 : 4'd7;
        4'd7: count <= (reset) ? 4'd1 : 4'd8;
        4'd8: count <= (reset) ? 4'd1 : 4'd9;
        4'd9: count <= (reset) ? 4'd1 : 4'd10;
        4'd10: count <= (reset) ? 4'd1 : 4'd1;
        default: count <= 4'd1;
    endcase
end

assign q = count;

endmodule