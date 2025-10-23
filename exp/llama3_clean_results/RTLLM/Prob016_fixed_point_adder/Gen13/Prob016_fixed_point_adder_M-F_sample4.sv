module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  clk,
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Internal register to store the result
reg [N-1:0] res;

// Sign bits of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Determine the operation based on the signs of the inputs
wire add = sign_a == sign_b;

// Perform the addition or subtraction
wire [N:0] sum;
assign sum = (add)? (a + b) : (a > b)? (a - b) : (b - a);

// Detect overflow
wire overflow = sum[N];

// Handle overflow
wire [N-1:0] result;
assign result = (overflow)? {1'b1, {N-1{1'b1}}} : sum[N-1:0];

// Assign the result to the output
always @(posedge clk) begin
    res <= result;
end

assign c = res;

endmodule