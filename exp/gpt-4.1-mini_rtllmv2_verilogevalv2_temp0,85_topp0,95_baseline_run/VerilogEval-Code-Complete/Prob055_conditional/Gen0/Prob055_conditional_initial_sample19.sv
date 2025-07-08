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

    ab_min = (a < b) ? a : b;
    cd_min = (c < d) ? c : d;
    min = (ab_min < cd_min) ? ab_min : cd_min;
  end

endmodule