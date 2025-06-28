module TopModule (
  input [2:0] in,
  output [1:0] out
);

  reg [1:0] count;

  always @(*) begin
    count = 0;
    for (int i = 0; i < 3; i = i + 1) begin
      if (in[i] == 1'b1) begin
        count = count + 1;
      end
    end
  end

  assign out = count;

endmodule