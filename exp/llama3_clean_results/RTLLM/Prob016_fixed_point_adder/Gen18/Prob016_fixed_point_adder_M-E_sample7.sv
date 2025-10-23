module fixed_point_adder #(
    parameter N = 16, // Total number of bits
    parameter Q = 8   // Number of fractional bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

    // Separate integer and fractional parts
    wire signed [N-Q-1:0] a_int = a[N-1:N-Q];
    wire signed [Q-1:0] a_frac = a[Q-1:0];
    wire signed [N-Q-1:0] b_int = b[N-1:N-Q];
    wire signed [Q-1:0] b_frac = b[Q-1:0];

    // Dual-path ALU for integer and fractional parts
    wire signed [N-Q:0] int_sum;
    wire signed [Q:0] frac_sum;

    // Control unit signals
    wire add_sub_sel; // 1 for addition, 0 for subtraction
    wire [N-1:0] result;

    // Overflow detection signals
    wire int_overflow;
    wire frac_overflow;

    // Determine operation (addition or subtraction) based on signs
    assign add_sub_sel = (a[N-1] == b[N-1]);

    // Integer part ALU
    assign int_sum = (add_sub_sel) ? (a_int + b_int) : (a_int - b_int);

    // Fractional part ALU
    assign frac_sum = (add_sub_sel) ? (a_frac + b_frac) : (a_frac - b_frac);

    // Overflow detection
    assign int_overflow = (int_sum[N-Q] != int_sum[N-Q-1]);
    assign frac_overflow = (frac_sum[Q] != frac_sum[Q-1]);

    // Control unit: construct result
    always @(*) begin
        if (int_overflow || frac_overflow) begin
            // Handle overflow
            result = (add_sub_sel) ? {1'b0, {N-1{1'b1}}} : {N{1'b0}};
        end else begin
            // Construct result without overflow
            result = {int_sum[N-Q-1:0], frac_sum[Q-1:0]};
            // Apply sign bit
            if (a[N-1] == 1'b1) begin
                result[N-1] = 1'b1;
            end
        end
    end

    assign c = result;

endmodule