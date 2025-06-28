module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

  always @* begin
    // Initialize output to 0
    out = 0;

    // Iterate over each bit in the input vector and count the number of '1's
    for (int i = 0; i < 255; i = i + 1) begin
      if (in[i] == 1) begin
        out = out + 1;
      end
    end
  end

endmodule