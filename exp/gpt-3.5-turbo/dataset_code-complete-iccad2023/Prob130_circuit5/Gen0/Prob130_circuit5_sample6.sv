module TopModule (
  input [3:0] a,
  input [3:0] b,
  input [3:0] c,
  input [3:0] d,
  input [3:0] e,
  output reg [3:0] q
);

always @* begin
  case (c)
    4'd0: q = a;
    4'd1: q = b;
    4'd2: q = c;
    4'd3: q = d;
    4'd4: q = e;
    default: q = 4'hf;
  endcase
end

endmodule