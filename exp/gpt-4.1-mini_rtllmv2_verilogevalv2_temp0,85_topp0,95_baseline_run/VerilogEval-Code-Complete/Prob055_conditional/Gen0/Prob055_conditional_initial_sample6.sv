module TopModule (
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  input [7:0] d,
  output reg [7:0] min
);

  always @(*) begin
    reg [7:0] ab_min;
    reg [7:0] cd_min;
    // find min between a and b
    ab_min = (a < b) ? a : b;
    // find min between c and d
    cd_min = (c < d) ? c : d;
    // final minimum between ab_min and cd_min
    min = (ab_min < cd_min) ? ab_min : cd_min;
  end

endmodule