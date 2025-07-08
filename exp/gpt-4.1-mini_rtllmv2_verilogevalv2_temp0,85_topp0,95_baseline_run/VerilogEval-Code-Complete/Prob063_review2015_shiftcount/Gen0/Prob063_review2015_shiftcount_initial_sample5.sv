module TopModule (
  input clk,
  input shift_ena,
  input count_ena,
  input data,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (shift_ena) begin
      q <= {q[2:0], data};  // shift left in MSB-first order, shifting data into LSB? 
      // Actually, MSB first means data enters at MSB, so shift right:
      // Correcting: shift right, new data at MSB
      // So update: q <= {data, q[3:1]};
    end else if (count_ena) begin
      q <= q - 1;
    end
  end

endmodule