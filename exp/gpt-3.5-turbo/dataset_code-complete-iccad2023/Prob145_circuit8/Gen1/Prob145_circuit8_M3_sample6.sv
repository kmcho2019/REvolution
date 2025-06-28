module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg [1:0] state;

always @(posedge clock) begin
  case(state)
    0: begin
      p <= 0;
      q <= 0;
      if (a) state <= 1;
    end
    1: begin
      p <= 1;
      q <= 0;
      if (!a) state <= 0;
      else state <= 2;
    end
    2: begin
      p <= 1;
      q <= 1;
      if (!a) state <= 0;
    end
  endcase
end

endmodule