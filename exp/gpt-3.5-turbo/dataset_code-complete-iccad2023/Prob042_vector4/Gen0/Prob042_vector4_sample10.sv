module sign_extension (
  input [7:0] in,
  output reg [31:0] out
);

always @(*) begin
  out = { {24{in[7]}}, in };
end

endmodule

module TopModule (
  input [7:0] in,
  output [31:0] out
);

sign_extension se(.in(in), .out(out));

endmodule