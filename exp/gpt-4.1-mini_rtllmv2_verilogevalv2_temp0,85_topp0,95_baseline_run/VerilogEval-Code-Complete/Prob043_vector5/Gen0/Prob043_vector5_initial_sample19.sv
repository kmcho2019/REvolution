module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);
  wire [4:0] inputs = {a,b,c,d,e};
  integer i,j;
  reg [24:0] temp_out;

  always @(*) begin
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5; j = j + 1) begin
        // Compute index: row i (a=0..4), column j (a=0..4)
        // Index in out = 24 - (i*5 + j)
        // Set bit to 1 if inputs[i] == inputs[j]
        temp_out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
      end
    end
  end

  assign out = temp_out;
endmodule