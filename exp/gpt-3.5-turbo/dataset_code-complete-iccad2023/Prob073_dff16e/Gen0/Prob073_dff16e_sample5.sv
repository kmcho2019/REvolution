module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

  reg [7:0] q_low, q_high;

  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      q_low <= 8'b0;
      q_high <= 8'b0;
    end
    else begin
      // Update lower byte if byteena[0] is asserted
      if (byteena[0])
        q_low <= d[7:0];
      
      // Update upper byte if byteena[1] is asserted
      if (byteena[1])
        q_high <= d[15:8];
    end
  end

  always @* begin
    // Concatenate the lower and upper bytes
    q = {q_high, q_low};
  end

endmodule