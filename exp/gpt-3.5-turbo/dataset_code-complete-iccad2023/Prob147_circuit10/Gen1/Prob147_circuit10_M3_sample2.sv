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
      state_next = (a == 1 && b == 1) ? 2'b01 : 2'b00;
      q = 1'b0;
    end
    2'b01: begin
      state_next = (a == 1 && b == 0) ? 2'b11 : 2'b00;
      q = (state_reg == 2'b01) ? 1'b1 : 1'b0; // Output 'q' becomes 1 if previous state was 01
    end
    2'b11: begin
      state_next = (a == 0 && b == 1) ? 2'b10 : 2'b00;
      q = 1'b0;
    end
    2'b10: begin
      state_next = (a == 1 && b == 1) ? 2'b11 : 2'b00;
      q = (state_reg == 2'b10) ? 1'b1 : 1'b0; // Output 'q' becomes 1 if previous state was 10
    end
    default: begin
      state_next = 2'b00;
      q = 1'b0;
    end
  endcase
end

assign state = (state_reg == 2'b01 || state_reg == 2'b10) ? 1'b1 : 1'b0; // Output 'state' is 1 if previous state was 01 or 10

endmodule