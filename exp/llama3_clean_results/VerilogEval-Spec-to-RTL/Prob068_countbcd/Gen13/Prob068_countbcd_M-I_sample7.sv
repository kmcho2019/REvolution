module BCD_Counter(
    input  clk,
    input  reset,
    output [15:0] q,
    output [2:0] ena
);

reg [15:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (count == 16'd9999) begin
            count <= 16'd0;
        end else begin
            count <= count + 1;
        end
    end
end

assign q = count;
assign ena[0] = (count[3:0] == 4'd9) && (count[7:4] != 4'd9);
assign ena[1] = (count[7:4] == 4'd9) && (count[11:8] != 4'd9);
assign ena[2] = (count[11:8] == 4'd9) && (count[15:12] != 4'd9);

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

BCD_Counter counter(
  .clk(clk),
  .reset(reset),
  .q(q),
  .ena(ena)
);

endmodule