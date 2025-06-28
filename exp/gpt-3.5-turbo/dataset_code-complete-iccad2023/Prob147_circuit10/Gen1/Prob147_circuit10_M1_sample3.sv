module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg current_state;

// Initialize state to 2'b00
always @(*) begin
  case ({a, b})
    2'b00: current_state <= 2'b00;
    2'b01: current_state <= 2'b01;
    2'b10: current_state <= 2'b10;
    2'b11: current_state <= 2'b11;
  endcase
end

always @(posedge clk) begin
  case (current_state)
    2'b00: begin
      q <= 0;
      state <= 0;
    end
    2'b01: begin
      q <= 1;
      state <= 0;
    end
    2'b10: begin
      q <= 1;
      state <= 1;
    end
    2'b11: begin
      q <= 0;
      state <= 1;
    end
    default: begin
      q <= 0;
      state <= 0;
    end
  endcase
end

endmodule