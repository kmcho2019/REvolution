module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] state_next;
always @(posedge clk) begin
  state <= state_next;
end

always @(*) begin
  case (state)
    2'b00: begin
      state_next = (a & !b) ? 2'b01 : 2'b00;
      q = 1'b0;
    end
    2'b01: begin
      state_next = (a & b) ? 2'b11 : 2'b00;
      q = 1'b1;
    end
    2'b11: begin
      state_next = (!a & b) ? 2'b10 : 2'b00;
      q = 1'b0;
    end
    2'b10: begin
      state_next = (a & b) ? 2'b11 : 2'b00;
      q = 1'b1;
    end
    default: begin
      state_next = 2'b00;
      q = 1'b0;
    end
  endcase
end

endmodule