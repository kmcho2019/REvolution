module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg signed [N-1:0] a_s, b_s;
    reg signed [N-1:0] res;

    always @* begin
        a_s = $signed(a);
        b_s = $signed(b);

        if (a_s[N-1] == b_s[N-1]) begin
            // Same sign: add directly
            res = a_s + b_s;
        end else begin
            // Different sign: subtract smaller magnitude from larger magnitude
            if ($signed(a_s[N-2:0]) >= $signed(b_s[N-2:0])) begin
                res = a_s - b_s;
            end else begin
                res = b_s - a_s;
            end
        end

        c = res;
    end

endmodule