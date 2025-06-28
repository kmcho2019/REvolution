module TopModule (
  input [31:0] in,
  output [31:0] out
);

  reg [7:0] temp;
  reg [31:0] reversed_out;
  integer i;

  always @* begin
    reversed_out = 32'b0;
    for (i = 0; i < 32; i = i + 8) begin
      temp = in[i+7:i];
      reversed_out = {reversed_out, temp};
    end
    out = reversed_out;
  end

endmodule