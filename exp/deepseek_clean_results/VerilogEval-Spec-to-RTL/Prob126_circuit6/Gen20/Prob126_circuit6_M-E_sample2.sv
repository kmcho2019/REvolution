module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] base_pattern = {a, a, a, a, a, a[2:1]};
wire [15:0] transformed = (base_pattern ^ 16'h0F0F) << (a + 1);
wire [15:0] mask = 16'h1232 >> a;

assign q = (a == 3'd0) ? 16'h1232 :
           (a == 3'd1) ? (transformed | 16'hA000) :
           (a == 3'd2) ? (transformed ^ 16'h27D4) :
           (a == 3'd3) ? (transformed & 16'h5A0E) :
           (a == 3'd4) ? (transformed + 16'h2066) :
           (a == 3'd5) ? (transformed ^ mask) :
           (a == 3'd6) ? (transformed | mask) :
           (a == 3'd7) ? (transformed & mask) :
           16'h0000;

endmodule