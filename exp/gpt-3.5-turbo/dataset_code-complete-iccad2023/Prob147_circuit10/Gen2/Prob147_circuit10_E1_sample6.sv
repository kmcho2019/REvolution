module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] current_state, next_state;

always @(posedge clk) begin
  current_state <= next_state; // Update state at positive edge of clock

  case(current_state)
    2'b00: begin
      if (a == 1 && b == 0) begin
        q = 1;
        next_state = 1;
        state = 0;
      end else begin
        q = 0;
        next_state = 0;
        state = 0;
      end
    end
    2'b01: begin
      if (a == 0 && b == 0) begin
        q = 0;
        next_state = 0;
        state = 0;
      end else begin
        q = 1;
        next_state = 1;
        state = 0;
      end
    end
    2'b10: begin
      if (a == 1 && b == 1) begin
        q = 1;
        next_state = 3;
        state = 0;
      end else begin
        q = 1;
        next_state = 2;
        state = 0;
      end
    end
    2'b11: begin
      if (a == 0 && b == 0) begin
        q = 0;
        next_state = 2;
        state = 1;
      end else begin
        q = 1;
        next_state = 3;
        state = 1;
      end
    end
  endcase
end

endmodule