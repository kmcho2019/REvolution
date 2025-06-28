module TopModule (
  input clk,
  input d,
  output reg q
);

reg [1:0] clk_state;
reg q_temp;

always @(posedge clk)
begin
  if(clk_state == 2'b01) begin
    q_temp <= d; // Capture input on falling edge 
  end
  clk_state <= {clk_state[0], ~clk_state[1]}; // Toggle clk_state on every posedge
end

always @(posedge clk)
begin
  if(clk_state == 2'b10) begin
    q <= q_temp; // Assign stored value to q on rising edge
  end
end

endmodule