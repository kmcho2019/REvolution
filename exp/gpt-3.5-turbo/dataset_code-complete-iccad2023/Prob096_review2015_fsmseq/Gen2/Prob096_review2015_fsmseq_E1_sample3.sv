module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] shift_register = 4'b0;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    shift_register <= 4'b0;
    start_shifting <= 0;
  end
  else begin
    shift_register <= {shift_register[2:0], data};
    
    if (shift_register == 4'b1101) begin
      start_shifting <= 1;
    end
    else begin
      start_shifting <= 0;
    end
  end
end

endmodule