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
        ena <= 3'b0;
    end else begin
       counter <= counter + 1;

        // Decode counter value to get individual digits
        q[3:0] <= counter[3:0];
        q[7:4] <= counter[7:4];
        q[11:8] <= counter[11:8];
        q[15:12] <= counter[15:12];

        // Enable logic for upper three digits
        ena[1] <= (counter[3:0] == 4'b1001) ? 1'b1 : 1'b0;
        ena[2] <= (counter[7:4] == 4'b1001) ? 1'b1 : 1'b0;
        ena[3] <= (counter[11:8] == 4'b1001) ? 1'b1 : 1'b0;
    end
end

endmodule