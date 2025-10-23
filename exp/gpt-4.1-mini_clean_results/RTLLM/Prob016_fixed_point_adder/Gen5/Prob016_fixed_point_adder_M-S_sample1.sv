module fixed_point_adder #(
    parameter integer Q = 8,        // Number of fractional bits
    parameter integer N = 16        // Total bits including sign
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Signed interpretation
    wire signed [N-1:0] a_s = a;
    wire signed [N-1:0] b_s = b;

    // Perform addition with 1 extra bit for overflow detection
    wire signed [N:0] sum_ext = {a_s[N-1], a_s} + {b_s[N-1], b_s};
    wire signed [N-1:0] sum = sum_ext[N-1:0];

    // Detect overflow: operands same sign but sum sign differs
    wire overflow = (~(a_s[N-1] ^ b_s[N-1])) & (a_s[N-1] ^ sum[N-1]);

    // Saturation limits
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};

    always @* begin
        if (overflow) begin
            c = a_s[N-1] ? MIN_VAL : MAX_VAL;
        end else begin
            c = sum;
        end
    end

endmodule