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

// Combinational integer adder
wire [N-Q:0] int_sum;
assign int_sum = {1'b0} + int_a + int_b;

// Combinational fractional adder
wire [Q:0] frac_sum;
assign frac_sum = {1'b0} + frac_a + frac_b;

// Result combination and overflow handling
always @ (*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        c = {int_sum[N-Q-1:0], frac_sum[Q-1:0]};
    end else begin // Different signs
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (int_a >= int_b) begin
                c = {1'b0, int_a - int_b, frac_a - frac_b};
            end else begin
                c = {1'b1, int_b - int_a, frac_b - frac_a};
            end
        end else begin // a is negative, b is positive
            if (int_a >= int_b) begin
                c = {1'b1, int_a - int_b, frac_a - frac_b};
            end else begin
                c = {1'b0, int_b - int_a, frac_b - frac_a};
            end
        end
    end
end

endmodule