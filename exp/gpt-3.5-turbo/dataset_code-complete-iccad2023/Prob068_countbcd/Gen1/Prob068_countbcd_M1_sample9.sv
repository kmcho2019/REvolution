module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [15:0] counter = 16'b0;

always @(posedge clk) begin
    if (reset) begin
        counter <= 16'b0;
    end else begin
        counter <= counter + 1;
    end
end

assign q = counter;

assign ena[1] = (counter[3:0] == 4'b9);
assign ena[2] = (counter[7:4] == 4'b9);
assign ena[3] = (counter[11:8] == 4'b9);

endmodule