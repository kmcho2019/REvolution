module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg current_state, next_state;

always @(posedge clk) begin
  current_state <= next_state;
end

always @(*) begin
  next_state = current_state; // Default case

  case(current_state)
    2'b00: begin
      if(a == 1 && b == 0) next_state = 2'b01;
    end

    2'b01: next_state = 2'b10;

    2'b10: begin
      if(a == 1 && b == 1) next_state = 2'b11;
    end

    2'b11: next_state = 2'b00;
  endcase

  case(current_state)
    2'b00: begin
      q = 1'b0;
      state = 2'b00;
    end

    2'b01: begin
      q = 1'b1;
      state = 2'b01;
    end

    2'b10: begin
      q = 1'b1;
      state = 2'b10;
    end

    2'b11: begin
      q = 1'b1;
      state = 2'b11;
    end
  endcase
end

endmodule