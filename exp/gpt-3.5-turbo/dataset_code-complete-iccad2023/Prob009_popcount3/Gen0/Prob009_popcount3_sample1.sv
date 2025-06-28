module TopModule (
  input [2:0] in,
  output [1:0] out
);

  wire [2:0] in_copy;
  assign in_copy = in;
  
  reg [1:0] count;
  always @* begin
    count = 0;
    for (int i = 0; i < 3; i = i + 1) begin
      if (in_copy[i] == 1) begin
        count = count + 1;
      end
    end
  end

  assign out = count;
  
endmodule