module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [15:0] counter = 16'b0;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 16'b0;
    end else begin
        // Increment the counter on every clock cycle
        counter <= counter + 1;
    end
end

assign q[3:0] = counter[3:0];
assign q[7:4] = counter[7:4];
assign q[11:8] = counter[11:8];
assign q[15:12] = counter[15:12];

assign ena = counter[15:13] & ~reset;

endmodule