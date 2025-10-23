module fixed_point_adder #(
    parameter integer Q = 8,        // Number of fractional bits
    parameter integer N = 16        // Total bits including sign bit
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    // Internal variables for addition/subtraction with one extra bit for overflow detection
    reg signed [N:0] extended_res;

    always @* begin
        // If signs are the same, add directly
        if (a[N-1] == b[N-1]) begin
            extended_res = {a[N-1], a} + {b[N-1], b}; // extend sign bits for addition
            // Truncate to N bits (wrap-around behavior)
            c = extended_res[N-1:0];
        end else begin
            // Signs differ: perform subtraction of magnitudes
            // Compare absolute values to determine larger operand
            // Use signed abs: abs(x) = (x < 0) ? -x : x
            if ((a[N-1] ? -a : a) >= (b[N-1] ? -b : b)) begin
                extended_res = {a[N-1], a} - {b[N-1], b};
                c = extended_res[N-1:0];
            end else begin
                extended_res = {b[N-1], b} - {a[N-1], a};
                c = extended_res[N-1:0];
            end
        end
    end

endmodule