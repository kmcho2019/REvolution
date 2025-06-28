module BCD_Counter (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [3:0] bcd[3:0]; // Array to store BCD values of each digit

always @ (posedge clk) begin
  if (reset) begin
    q <= 16'b0;
    ena <= 4'b0;
    for (int i = 0; i < 4; i = i + 1)
      bcd[i] <= 4'b0;
  end else begin
    // Increment the ones digit
    if (bcd[0] == 4'b1001)
      bcd[0] <= 4'b0;
    else if (ena[1])
      bcd[0] <= bcd[0] + 4'b0001;
    
    // Generate enable signals for tens, hundreds, and thousands digits based on the ones digit
    if (bcd[0] == 4'b0001)
      ena <= 4'b001;
    else if (bcd[0] == 4'b1010)
      ena <= 4'b011;
    else if (bcd[0] == 4'b0010)
      ena <= 4'b101;
    
    // Increment tens, hundreds, and thousands digits based on respective enable signals
    for (int i = 1; i < 4; i = i + 1) begin
      if (ena[i] && bcd[i] == 4'b1001)
        bcd[i] <= 4'b0;
      else if (ena[i])
        bcd[i] <= bcd[i] + 4'b0001;
    end
    
    // Assign BCD values to q
    q = {bcd[3], bcd[2], bcd[1], bcd[0]};
  end
end

endmodule