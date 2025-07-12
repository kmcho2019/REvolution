module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Split inputs into integer and fractional parts
wire [N-Q-1:0] int_a = a[N-1:N-Q];
wire [Q-1:0] frac_a = a[N-Q-1:0];
wire [N-Q-1:0] int_b = b[N-1:N-Q];
wire [Q-1:0] frac_b = b[N-Q-1:0];

// Add integer parts
wire [N-Q:0] int_sum;
assign int_sum = {1'b0} + int_a + int_b;

// Add fractional parts
wire [Q:0] frac_sum;
assign frac_sum = {1'b0} + frac_a + frac_b;

// Detect overflow
wire overflow = int_sum[N-Q];

// Combine results, handling overflow
always @(*) begin
    if (overflow) begin
        // Handle overflow, for simplicity, we saturate at max value
        c = {N{1'b1}};
    end else begin
        // Combine integer and fractional parts
        c = {int_sum[N-Q-1:0], frac_sum[Q-1:0]};
    end
end

endmodule