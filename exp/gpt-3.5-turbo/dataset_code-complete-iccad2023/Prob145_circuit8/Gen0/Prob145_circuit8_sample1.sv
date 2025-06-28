module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg [1:0] state;

always @(posedge clock) begin
  case(state)
    2'b00: begin
      if (a == 0)
        state <= 2'b00;
      else
        state <= 2'b01;
    end
    2'b01: begin
      if (a == 1)
        state <= 2'b10;
      else
        state <= 2'b01;
    end
    2'b10: begin
      if (a == 0)
        state <= 2'b00;
      else
        state <= 2'b11;
    end
    2'b11: begin
      if (a == 1)
        state <= 2'b10;
      else
        state <= 2'b01;
    end
  endcase
end

always @(state) begin
  case(state)
    2'b00: begin
      p <= 0;
      q <= 0;
    end
    2'b01: begin
      p <= 0;
      q <= 0;
    end
    2'b10: begin
      p <= 1;
      q <= 0;
    end
    2'b11: begin
      p <= 1;
      q <= 1;
    end
  endcase
end

endmodule