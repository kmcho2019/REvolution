module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] state_next;
reg [2:0] input_history = 3'b0;

always @* begin
  case (state)
    2'b00: begin
      if ((input_history == 3'b011) && (a == 0 && b == 1))
        state_next = 2'b01;
      else
        state_next = 2'b00;
      q = 1'b0;
    end
    2'b01: begin
      if ((input_history == 3'b011) && (a == 1 && b == 0))
        state_next = 2'b11;
      else if (a == 1 && b == 1)
        state_next = 2'b00;
      else
        state_next = 2'b01;
      q = 1'b1;
    end
    2'b11: begin
      if ((input_history == 3'b011) && (a == 1 && b == 1))
        state_next = 2'b10;
      else if (a == 1 && b == 0)
        state_next = 2'b01;
      else
        state_next = 2'b00;
      q = 1'b0;
    end
    2'b10: begin
      if ((input_history == 3'b011) && (a == 0 && b == 0))
        state_next = 2'b00;
      else if (a == 1 && b == 1)
        state_next = 2'b11;
      else
        state_next = 2'b10;
      q = 1'b1;
    end
    default: begin
      state_next = 2'b00;
      q = 1'b0;
    end
  endcase
end

always @(posedge clk) begin
  state <= state_next;
  input_history <= {input_history[1:0], a & b};
end

endmodule