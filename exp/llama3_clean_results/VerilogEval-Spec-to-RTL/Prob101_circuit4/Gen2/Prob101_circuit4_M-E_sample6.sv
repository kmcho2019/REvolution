module TopModule(
  input  a,
  input  b,
  input  c,
  input  d,
  output q
);

  reg [3:0] lut [0:15];

  initial begin
    // Initialize the lookup table based on the observed behavior
    // The output q is 1 whenever b or c is 1, regardless of a and d
    for (int i = 0; i < 16; i++) begin
      if ((i[1] == 1'b1) || (i[2] == 1'b1)) begin
        lut[i] = 4'd1;
      end else begin
        lut[i] = 4'd0;
      end
    end
  end

  always @(*) begin
    // Convert the inputs into an index for the lookup table
    reg [3:0] index;
    index[0] = a;
    index[1] = b;
    index[2] = c;
    index[3] = d;
    
    // Use the lookup table to determine the output q
    q = lut[index];
  end

endmodule