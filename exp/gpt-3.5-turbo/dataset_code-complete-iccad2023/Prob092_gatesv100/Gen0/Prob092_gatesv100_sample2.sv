module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // Process for calculating 'out_both'
  genvar i_both;
  generate
    for (i_both = 0; i_both < 99; i_both = i_both + 1) begin : both_gen
      assign out_both[i_both] = in[i_both] & in[i_both + 1];
    end
  endgenerate

  // Process for calculating 'out_any'
  genvar i_any;
  generate
    for (i_any = 1; i_any < 100; i_any = i_any + 1) begin : any_gen
      assign out_any[i_any] = in[i_any] | in[i_any - 1];
    end
  endgenerate

  // Process for calculating 'out_different'
  genvar i_diff;
  generate
    for (i_diff = 0; i_diff < 99; i_diff = i_diff + 1) begin : diff_gen
      assign out_different[i_diff] = in[i_diff] ^ in[i_diff + 1];
    end
    // Handling wrap-around case for the last index
    assign out_different[99] = in[99] ^ in[0];
  endgenerate

endmodule