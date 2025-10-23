module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits
    parameter integer N = 16          // Total bits (including sign and fractional)
)(
    input  wire [N-1:0] a,            // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,            // Fixed-point operand b (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Extend inputs to signed (N+1)-bit to detect overflow and simplify addition
    wire signed [N:0] a_ext = {a[N-1], a};
    wire signed [N:0] b_ext = {b[N-1], b};

    // Internal register for extended result
    reg signed [N:0] res_ext;

    always @* begin
        // If sign bits are equal -> add
        if (a[N-1] == b[N-1]) begin
            res_ext = a_ext + b_ext;
        end else begin
            // Signs differ: subtract smaller magnitude from larger magnitude
            // Compare absolute values by comparing magnitudes ignoring sign bits
            // abs(a) = a_ext if positive, or -a_ext if negative
            // But simpler to compare unsigned magnitude of lower N bits since sign bit is handled
            // Compare absolute values:
            if (a_ext[N-1:0] >= b_ext[N-1:0]) begin
                res_ext = a_ext - b_ext;
            end else begin
                res_ext = b_ext - a_ext;
            end
        end

        // Truncate result to N bits (discard extended sign bit)
        // This naturally wraps overflow and preserves fixed-point format
        c = res_ext[N-1:0];
    end

endmodule