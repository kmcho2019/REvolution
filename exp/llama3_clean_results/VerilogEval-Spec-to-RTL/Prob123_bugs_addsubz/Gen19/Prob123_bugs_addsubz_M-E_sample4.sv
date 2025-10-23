module hybrid_adder_subtractor #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    output result_is_zero
);

    // First stage: Ripple-carry adder
    wire [WIDTH-1:0] sum_rc;
    wire carry_out_rc;
    ripple_carry_adder #(.WIDTH(WIDTH)) u_rc_adder (
       .a(a),
       .b(do_sub? (~b + 1) : b),
       .sum(sum_rc),
       .carry_out(carry_out_rc)
    );

    // Second stage: Parallel prefix adder
    wire [WIDTH-1:0] sum_pp;
    parallel_prefix_adder #(.WIDTH(WIDTH)) u_pp_adder (
       .a(a),
       .b(do_sub? (~b + 1) : b),
       .sum(sum_pp)
    );

    // Zero Flag Prediction (ZFP) circuit
    wire predicted_zero;
    zfp_circuit #(.WIDTH(WIDTH)) u_zfp (
       .a(a),
       .b(do_sub? (~b + 1) : b),
       .predicted_zero(predicted_zero)
    );

    // Control unit
    always @(*) begin
        if (predicted_zero) begin
            out = 0;
            result_is_zero = 1;
        end else begin
            out = sum_pp;
            result_is_zero = ~(| sum_pp);
        end
    end

endmodule

module ripple_carry_adder #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] sum,
    output carry_out
);

    wire [WIDTH-1:0] carry;
    assign carry[0] = a[0] & b[0];
    assign sum[0] = a[0] ^ b[0];

    for (genvar i = 1; i < WIDTH; i++) begin
        assign carry[i] = (a[i] & b[i]) | (carry[i-1] & (a[i] ^ b[i]));
        assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
    end

    assign carry_out = carry[WIDTH-1];

endmodule

module parallel_prefix_adder #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] sum
);

    wire [WIDTH-1:0] p, g;
    assign p = a | b;
    assign g = a & b;

    wire [WIDTH-1:0] carry;
    assign carry[0] = g[0];
    for (genvar i = 1; i < WIDTH; i++) begin
        assign carry[i] = g[i] | (p[i] & carry[i-1]);
    end

    assign sum = a ^ b ^ carry;

endmodule

module zfp_circuit #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output predicted_zero
);

    assign predicted_zero = ~(| (a ^ b));

endmodule