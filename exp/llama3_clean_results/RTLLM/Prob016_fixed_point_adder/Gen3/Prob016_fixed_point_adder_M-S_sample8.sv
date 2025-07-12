module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result
reg [N-Q-1:0] int_a, int_b; // Integer parts of a and b
reg [Q-1:0] frac_a, frac_b; // Fractional parts of a and b
reg [Q:0] frac_res; // Result of fractional part operation with extra bit for carry

always @(*) begin
    // Separate integer and fractional parts
    int_a = a[N-1:Q];
    int_b = b[N-1:Q];
    frac_a = a[Q-1:0];
    frac_b = b[Q-1:0];

    // Perform addition or subtraction based on signs
    if (a[N-1] == b[N-1]) begin
        // Same signs, add absolute values
        res = (a[N-1] == 1'b1) ? -(a + b) : (a + b);
    end else begin
        // Different signs, subtract
        if (a[N-1:0] > b[N-1:0]) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end

    // Handle overflow
    if (res >= (1 << (N-1))) begin
        res = (1 << (N-1)) - 1;
    end else if (res < -(1 << (N-1))) begin
        res = -(1 << (N-1));
    end

    c = res; // Assign the result to the output port
end

endmodule