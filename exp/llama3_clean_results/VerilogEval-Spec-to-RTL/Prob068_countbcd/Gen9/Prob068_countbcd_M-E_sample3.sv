module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [13:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 14'd0;
    end else begin
        if (count == 14'd9999) begin
            count <= 14'd0;
        end else begin
            count <= count + 1;
        end
    end
end

assign q[3:0] = count[3:0];
assign q[7:4] = count[7:4];
assign q[11:8] = count[11:8];
assign q[15:12] = count[15:12];

assign ena[0] = (count[3:0] == 4'd9);
assign ena[1] = (count[3:0] == 4'd9) && (count[7:4] == 4'd9);
assign ena[2] = (count[3:0] == 4'd9) && (count[7:4] == 4'd9) && (count[11:8] == 4'd9);

endmodule