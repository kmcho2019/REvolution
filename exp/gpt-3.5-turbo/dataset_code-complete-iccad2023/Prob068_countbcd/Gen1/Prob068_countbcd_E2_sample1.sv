module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [15:0] bcd_counter = 16'b0000; // BCD counter for all digits

always @ (posedge clk) begin
    if (reset) begin
        bcd_counter <= 16'b0000; // Reset all digits when reset is high
    end else begin
        // Increment the BCD counter on every clock cycle
        if (bcd_counter == 16'b1001_1001_1001_1001) begin
            bcd_counter <= 16'b0000;
        end else begin
            bcd_counter <= bcd_counter + 1;
        end
    end
end

// Decode the BCD counter values to individual digits based on enable signals
assign q[3:0] = bcd_counter[3:0]; // Ones digit always enabled
assign q[7:4] = (ena[1] == 1) ? bcd_counter[7:4] : 4'b0000; // Tens digit
assign q[11:8] = (ena[2] == 1) ? bcd_counter[11:8] : 4'b0000; // Hundreds digit
assign q[15:12] = (ena[3] == 1) ? bcd_counter[15:12] : 4'b0000; // Thousands digit

endmodule