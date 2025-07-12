module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  clk,
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine operation based on signs
wire add = a[N-1] == b[N-1];

// Perform addition or subtraction
wire [N:0] sum;
assign sum = (add)? (a + b) : (a > b)? (a - b) : (b - a);

// Overflow handling
wire [N-1:0] result;
assign result = (sum[N] == 1)? ((sum[N-1] == 1'b0)? {1'b0, {N-1{1'b1}}} : {N{1'b1}}) : sum[N-1:0];

always @(posedge clk) begin
    res <= result;
end

assign c = res;

endmodule