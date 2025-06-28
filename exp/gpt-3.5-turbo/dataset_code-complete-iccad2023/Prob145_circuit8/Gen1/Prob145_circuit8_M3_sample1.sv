module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg [1:0] state;

always @(*) begin
  case(state)
    2'b00: begin
      p <= 0;
      q <= 0;
      if (a)
        state <= 2'b01;
    end
    2'b01: begin
      if (a)
        state <= 2'b10;
      else
        state <= 2'b01;
    end
    2'b10: begin
      p <= 1;
      q <= 0;
      if (!a)
        state <= 2'b11;
    end
    2'b11: begin
      p <= 1;
      q <= 1;
      if (a)
        state <= 2'b10;
    end
  endcase
end

always @(posedge clock) begin
  state <= state; // Retain current state at clock edges
end

endmodule