module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

  reg [3:0] inputs;
  
  always @* begin
    inputs = {a, b, c, d};
    if (inputs == 4'b0001 || inputs == 4'b0010 || inputs == 4'b0100 || inputs == 4'b1000) begin
      q = 1;
    end
    else begin
      q = 0;
    end
  end

endmodule