module fixed_point_adder #(
    parameter Q = 8,        // Fractional bits (default 8)
    parameter N = 16        // Total bits (default 16)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output wire overflow
);

    // Internal signals
    wire [N:0] sum_ext;      // Extended sum for carry detection
    wire a_sign, b_sign;
    wire overflow_pos, overflow_neg;
    
    // Sign bits
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    
    // Extended addition for carry detection
    assign sum_ext = {a_sign, a} + {b_sign, b};
    
    // Overflow detection
    assign overflow_pos = (~a_sign & ~b_sign & sum_ext[N]);  // Positive overflow
    assign overflow_neg = (a_sign & b_sign & ~sum_ext[N]);   // Negative overflow
    assign overflow = overflow_pos | overflow_neg;
    
    // Saturation logic with direct assignment
    always @(*) begin
        if (overflow_pos)
            c = {1'b0, {(N-1){1'b1}}};    // Saturate to max positive
        else if (overflow_neg)
            c = {1'b1, {(N-1){1'b0}}};    // Saturate to max negative
        else
            c = sum_ext[N-1:0];          // Normal case
    end

endmodule