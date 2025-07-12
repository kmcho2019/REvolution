module fixed_point_adder #(
    parameter N = 16,  // Total bits
    parameter Q = 8    // Fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output wire overflow
);

    // Internal result register
    reg [N-1:0] res;

    always @(*) begin
        // Direct two's complement addition
        res = a + b;
        c = res;
    end

    // Overflow detection
    assign overflow = (~a[N-1] & ~b[N-1] & res[N-1]) |  // Positive overflow
                     (a[N-1] & b[N-1] & ~res[N-1]);     // Negative overflow

endmodule