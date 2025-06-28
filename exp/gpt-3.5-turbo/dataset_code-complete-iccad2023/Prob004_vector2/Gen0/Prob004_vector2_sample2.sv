module TopModule (
  input [31:0] in,
  output [31:0] out
);

  reg [31:0] temp;

  always @* begin
    for (int i = 0; i < 32; i=i+8) begin
      temp[i+7:i] = in[31-i:24-i];
    end
    out = temp;
  end
endmodule