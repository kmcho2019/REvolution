module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg [1:0] counter;

always @(posedge clock) begin
  if (a == 1) begin
    counter <= (counter == 2'b11) ? 2'b00 : counter + 1;
  end
  else begin
    counter <= 2'b00;
  end
  
  case (counter)
    2'b00: begin
      p <= 0;
      q <= 0;
    end
    2'b01: begin
      p <= 1;
      q <= 0;
    end
    2'b10: begin
      p <= 0;
      q <= 1;
    end
    2'b11: begin
      p <= 1;
      q <= 1;
    end
  endcase
end

endmodule