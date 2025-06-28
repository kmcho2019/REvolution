module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [13:0] bcd_count = 14'b0000;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bcd_count <= 14'b0000;
    end else begin
        // Increment BCD counter
        bcd_count <= (bcd_count == 14'b1001_1001_1001_1001) ? 14'b0000 : bcd_count + 1;
    end
end

// Assign individual digits based on BCD counter value
always @* begin
    q[3:0] = bcd_count[3:0]; // Ones digit
    q[7:4] = bcd_count[7:4]; // Tens digit
    q[11:8] = bcd_count[11:8]; // Hundreds digit
    q[15:12] = bcd_count[15:12]; // Thousands digit
end

// Assign individual enables for each digit
assign ena[1] = (bcd_count[3:0] == 4'b1001) ? 1'b1 : 1'b0; // Tens digit enable
assign ena[2] = (bcd_count[7:4] == 4'b1001) ? 1'b1 : 1'b0; // Hundreds digit enable
assign ena[3] = (bcd_count[11:8] == 4'b1001) ? 1'b1 : 1'b0; // Thousands digit enable

endmodule