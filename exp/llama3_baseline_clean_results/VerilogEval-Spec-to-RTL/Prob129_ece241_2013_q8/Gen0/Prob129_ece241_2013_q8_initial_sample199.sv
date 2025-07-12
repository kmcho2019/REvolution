module TopModule(
  input clk,
  input aresetn,
  input x,
  output z
);

reg [1:0] state;
reg [1:0] next_state;
reg z_reg;

always @(posedge clk or negedge aresetn) begin
  if (!aresetn) begin
    state <= 2'b00;
    z_reg <= 1'b0;
  end else begin
    state <= next_state;
    z_reg <= (state == 2'b01 && x == 1'b1) || (state == 2'b10 && x == 1'b1);
  end
end

always @(*) begin
  case(state)
    2'b00: next_state = x ? 2'b01 : 2'b00;
    2'b01: next_state = x ? 2'b01 : 2'b10;
    2'b10: next_state = x ? 2'b01 : 2'b00;
  endcase
end

assign z = z_reg;

endmodule