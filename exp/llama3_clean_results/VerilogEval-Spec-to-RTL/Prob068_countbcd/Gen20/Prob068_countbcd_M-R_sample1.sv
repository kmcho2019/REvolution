module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else if (count == 16'd9999) begin
        count <= 16'd0;
    end else begin
        count <= count + 1;
    end
end

assign q[3:0] = count % 10;
assign q[7:4] = (count / 10) % 10;
assign q[11:8] = (count / 100) % 10;
assign q[15:12] = count / 1000;

assign ena[0] = (count % 10 == 9);
assign ena[1] = ((count / 10) % 10 == 9) && (count % 10 == 9);
assign ena[2] = ((count / 100) % 10 == 9) && ((count / 10) % 10 == 9) && (count % 10 == 9);

endmodule