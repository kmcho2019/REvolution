module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [11:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 12'd0;
    end else begin
        count <= (count == 12'd9999) ? 12'd0 : count + 1;
    end
end

assign q = {count[11:8], count[7:4], count[3:0], 4'd0};
assign ena[0] = (count[3:0] == 4'd9);
assign ena[1] = (count[3:0] == 4'd9) && (count[7:4] == 4'd9);
assign ena[2] = (count[3:0] == 4'd9) && (count[7:4] == 4'd9) && (count[11:8] == 4'd9);

endmodule