module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  clk, // Clock signal
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
wire sub = ~add;

// Perform the addition or subtraction using a single adder
wire [N:0] sum;
assign sum = (add)? (a + b) : (a + (~b + 1)); // Using two's complement for subtraction

// Detect overflow
wire overflow = sum[N];

// Handle overflow efficiently by saturating the result
wire [N-1:0] result;
assign result = (overflow)? ((sign_a == 1'b0)? {1'b0, {N-1{1'b1}}} : {N{1'b1}}) : sum[N-1:0];

// Assign the result to the output synchronously
always @(posedge clk) begin
    res <= result;
end

assign c = res;

endmodule