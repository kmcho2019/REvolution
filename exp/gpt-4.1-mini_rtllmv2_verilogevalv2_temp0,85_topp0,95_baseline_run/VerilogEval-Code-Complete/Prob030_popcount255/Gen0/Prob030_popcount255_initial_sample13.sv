module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

  integer i;

  // We'll sum all bits by adding them iteratively
  // A simple approach: sum bits directly in a for loop (synthesizable)
  reg [15:0] count; // enough width to hold up to 255

  always @(*) begin
    count = 0;
    for (i = 0; i < 255; i = i + 1) begin
      count = count + in[i];
    end
    out = count[7:0];
  end

endmodule