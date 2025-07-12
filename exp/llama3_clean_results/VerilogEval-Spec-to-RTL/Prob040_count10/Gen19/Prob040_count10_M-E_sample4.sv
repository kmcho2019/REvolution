module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] lut_value;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (count == 4'd9) begin
        count <= 4'd0;
    end else begin
        count <= count + 1;
    end
end

always @(posedge clk) begin
    case (count)
        4'd0: lut_value <= 4'd0;
        4'd1: lut_value <= 4'd1;
        4'd2: lut_value <= 4'd2;
        4'd3: lut_value <= 4'd3;
        4'd4: lut_value <= 4'd4;
        4'd5: lut_value <= 4'd5;
        4'd6: lut_value <= 4'd6;
        4'd7: lut_value <= 4'd7;
        4'd8: lut_value <= 4'd8;
        4'd9: lut_value <= 4'd9;
        default: lut_value <= 4'd0;
    endcase
end

assign q = lut_value;

endmodule