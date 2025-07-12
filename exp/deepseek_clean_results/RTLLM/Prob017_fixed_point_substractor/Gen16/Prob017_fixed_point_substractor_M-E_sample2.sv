module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign-extended inputs (N+1 bits)
    wire [N:0] a_ext = {a[N-1], a};
    wire [N:0] b_ext_neg = {~b[N-1], ~b} + 1'b1;  // Two's complement of b

    // Parallel prefix addition (Brent-Kung structure)
    wire [N:0] sum;
    wire [N:0] carry;
    
    // Generate and propagate signals
    wire [N:0] g = a_ext & b_ext_neg;
    wire [N:0] p = a_ext ^ b_ext_neg;
    
    // Carry computation
    assign carry[0] = 1'b0;
    genvar i;
    generate
        for (i = 1; i <= N; i = i + 1) begin : carry_chain
            assign carry[i] = g[i-1] | (p[i-1] & carry[i-1]);
        end
    endgenerate
    
    // Sum computation
    assign sum = p ^ carry;

    // Result processing
    wire overflow = sum[N] ^ sum[N-1];
    wire [N-1:0] result = overflow ? {sum[N], sum[N-2:0]} : sum[N-1:0];
    
    // Zero detection and sign correction
    wire is_zero = (result[N-1:0] == {N{1'b0}});
    assign c = is_zero ? {N{1'b0}} : result;

endmodule