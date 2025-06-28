module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] state_reg, state_next;

always @(posedge clk) begin
  state_reg <= state_next;
end

always @(*) begin
  case (state_reg)
    2'b00: begin
      if (b == 1 && $changed(b)) state_next = 2'b01;
      else state_next = 2'b00;
    end
    2'b01: begin
      if (a == 0 && $changed(a)) state_next = 2'b10;
      else state_next = 2'b01;
    end
    2'b10: begin
      state_next = 2'b00;
    end
    default: begin
      state_next = 2'b00;
    end
  endcase
end

always @(*) begin
  case (state_reg)
    2'b00: q = 1'b0;
    2'b01: q = 1'b0;
    2'b10: q = 1'b1;
  endcase
end

assign state = state_reg;

endmodule