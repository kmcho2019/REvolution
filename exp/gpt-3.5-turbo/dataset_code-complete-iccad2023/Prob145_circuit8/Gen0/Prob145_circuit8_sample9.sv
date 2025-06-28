module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg [1:0] state;

always @(posedge clock) begin
  case (state)
    0: begin
      p <= 0;
      q <= 0;
      if (a == 1) begin
        state <= 1;
      end
    end
    1: begin
      p <= 1;
      q <= 0;
      if (a == 0) begin
        state <= 0;
      end
      else begin
        state <= 2;
      end
    end
    2: begin
      p <= 1;
      q <= 1;
      if (a == 0) begin
        state <= 0;
      end
    end
  endcase
end

endmodule