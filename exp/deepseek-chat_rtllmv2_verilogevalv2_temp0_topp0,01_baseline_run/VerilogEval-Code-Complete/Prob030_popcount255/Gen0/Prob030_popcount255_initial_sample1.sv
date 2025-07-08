module TopModule (
  input [254:0] in,
  output reg [7:0] out
);

  // Intermediate sums for each 8-bit segment (32 segments total)
  wire [7:0] segment_counts [0:31];
  
  // Generate counts for each 8-bit segment (except last which is 7 bits)
  genvar i;
  generate
    for (i = 0; i < 31; i = i + 1) begin : segment_8bit
      assign segment_counts[i] = 
        in[i*8+0] + in[i*8+1] + in[i*8+2] + in[i*8+3] + 
        in[i*8+4] + in[i*8+5] + in[i*8+6] + in[i*8+7];
    end
    // Last segment (7 bits)
    assign segment_counts[31] = 
      in[248] + in[249] + in[250] + in[251] + 
      in[252] + in[253] + in[254];
  endgenerate

  // Sum all segment counts
  always @(*) begin
    out = 0;
    for (integer j = 0; j < 32; j = j + 1) begin
      out = out + segment_counts[j];
    end
  end

endmodule