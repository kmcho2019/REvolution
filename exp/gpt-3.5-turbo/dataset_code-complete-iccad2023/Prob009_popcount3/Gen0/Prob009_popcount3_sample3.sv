module TopModule (
  input [2:0] in,
  output [1:0] out
);

  reg [1:0] count;
  assign out = count;

  always @* begin
    count = 0;
    for (int i = 0; i < 3; i = i + 1) begin
      if (in[i] == 1'b1) begin
        count = count + 2'b01;
      end
    end
  end

endmodule