module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Extract sign bits
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Split operands into integer and fractional parts
wire [N-Q-1:0] int_a = a[N-1:Q];
wire [N-Q-1:0] int_b = b[N-1:Q];
wire [Q-1:0]   frac_a = a[Q-1:0];
wire [Q-1:0]   frac_b = b[Q-1:0];

// Determine operation based on sign bits
wire add = sign_a == sign_b;
wire sub = ~add;

// Perform addition/subtraction on integer parts
wire [N-Q:0] int_res;
assign int_res = add ? (int_a + int_b) : (sub && (int_a > int_b)) ? (int_a - int_b) : (int_b - int_a);

// Perform addition/subtraction on fractional parts
wire [Q:0] frac_res;
assign frac_res = add ? (frac_a + frac_b) : (sub && (int_a > int_b)) ? (frac_a - frac_b) : (frac_b - frac_a);

// Combine results, handling carry from fractional part
wire [N-1:0] res;
assign res = {int_res[N-Q-1:0], frac_res[Q-1:0]} + { {(N-Q){frac_res[Q]}}, {Q{1'b0}} };

// Assign final result, ensuring sign consistency
assign c = add ? res : (res[N-1] == 0) ? res : (~res + 1);

endmodule